provider "docker" {
  host      = "tcp://esme.gruenehoelle.nl:2376/"
  cert_path = pathexpand(var.docker_cert_path)

  alias = "esme"
}
