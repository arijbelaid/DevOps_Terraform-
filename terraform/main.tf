terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# VM1
provider "docker" {
  alias = "vm1"
  host  = "ssh://vagrant@192.168.56.20:22"
}

# VM2
provider "docker" {
  alias = "vm2"
  host  = "ssh://vagrant@192.168.56.21:22"
}

# Image CV pour VM1
resource "docker_image" "cv_vm1" {
  provider     = docker.vm1
  name         = "mon-cv:latest"
  build {
    context = "." # Le Dockerfile est dans le dossier parent
  }
}

resource "docker_container" "cv_vm1" {
  provider = docker.vm1
  image    = docker_image.cv_vm1.image_id
  name     = "cv_one_page_vm1"
  ports {
    internal = 80
    external = 8001
  }
}

# Image CV pour VM2
resource "docker_image" "cv_vm2" {
  provider     = docker.vm2
  name         = "mon-cv:latest"
  build {
    context = "."
  }
}

resource "docker_container" "cv_vm2" {
  provider = docker.vm2
  image    = docker_image.cv_vm2.image_id
  name     = "cv_one_page_vm2"
  ports {
    internal = 80
    external = 8002
  }
}
