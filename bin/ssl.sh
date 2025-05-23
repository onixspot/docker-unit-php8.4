#!/usr/bin/env bash

export DATA_DIR="${HOME}/.app"

before_execute() {
  mkdir -p "${DATA_DIR}"
}

make_ssl_certificate() {
  local certPath keyPath bundlePath \
    domainName

  domainName="$1"
  certPath="${domainName}"/certificate.crt
  keyPath="${domainName}"/private.key
  bundlePath="${domainName}"/ca-budle.pem

  openssl req -x509 -out "${certPath}" -keyout "${keyPath}" \
    -newkey rsa:2048 -nodes -sha256 \
    -subj /CN="${domainName}" -extensions EXT -config <(
      cat <<EOF
[dn]
CN=${domainName}
[req]
distinguished_name = dn
[EXT]
subjectAltName=DNS:${domainName}
keyUsage=digitalSignature
extendedKeyUsage=serverAuth
EOF
    )
  cat "${certPath}" "${keyPath}" >"${bundlePath}"
  cp "${certPath}" /usr/local/share/ca-certificates/
  update-ca-certificates
}

update_certificates() {
  cp --remove-destination "${certPath}" /usr/local/share/ca-certificates/
  update-ca-certificates
}

main() {
  before_execute

  case "$1" in
  make:cert) make_ssl_certificate "${@:2}" ;;
  **)
    cat <<EOF
Usage:
  command [arguments]

Available commands:
  make:cert <domain_name>           Create a new ssl certificate based on <domain_name> of the web resource
EOF
    ;;
  esac
}

main "${@}"
