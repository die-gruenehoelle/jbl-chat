variable "database_url" {}

resource "docker_network" "service" {
  provider = docker.esme

  name            = var.app_name
  check_duplicate = true
}

##############
# docker image
##############
data "docker_registry_image" "main" {
  provider = docker.esme

  name = "lifeofguenter/jbl-chat:1.2"
}

resource "docker_image" "main" {
  provider = docker.esme

  name          = data.docker_registry_image.main.name
  pull_triggers = [data.docker_registry_image.main.sha256_digest]
  keep_locally  = true

  lifecycle {
    create_before_destroy = true
  }
}

##################
# docker container
##################
resource "docker_container" "main" {
  provider = docker.esme

  name  = var.app_name
  image = docker_image.main.image_id

  memory = 512

  restart = "always"

  env = [
    "DATABASE_URL=${var.database_url}"
  ]

  labels {
    label = "traefik.enable"
    value = "true"
  }

  labels {
    label = "traefik.docker.network"
    value = "services"
  }

  labels {
    label = "traefik.http.routers.jbl_chat_http.entryPoints"
    value = "web"
  }

  labels {
    label = "traefik.http.routers.jbl_chat_http.rule"
    value = "Host(`jbl-chat.gruenehoelle.nl`)"
  }

  labels {
    label = "traefik.http.routers.jbl_chat_http.middlewares"
    value = "cloudflare_whitelist@file,https_redirect@file"
  }

  labels {
    label = "traefik.http.routers.jbl_chat_https.entryPoints"
    value = "web_secure"
  }

  labels {
    label = "traefik.http.routers.jbl_chat_https.rule"
    value = "Host(`jbl-chat.gruenehoelle.nl`)"
  }

  labels {
    label = "traefik.http.routers.jbl_chat_https.tls.certresolver"
    value = "default"
  }

  labels {
    label = "traefik.http.routers.jbl_chat_https.middlewares"
    value = "cloudflare_whitelist@file,compression@file"
  }

  networks_advanced {
    name = docker_network.service.name
  }

  networks_advanced {
    name = "services"
  }
}
