resource "google_compute_instance" "default" {
  name         = "virtual-machine-from-terraform"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  metadata = {
    ssh-keys = "root:${file("/path/to/public/key/id_rsa.pub")}"
  }

    metadata_startup_script = "sudo apt-get update && sudo apt-get install -y nginx"

    // Apply the firewall rule to allow external IPs to access this instance
    tags = ["http-server", "ssh-access"]
}

resource "google_compute_firewall" "http-server" {
  name    = "allow-http-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "ssh-server" {
  name    = "allow-ssh-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  // Allow traffic from everywhere to instances with an ssh-access tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-access"]
}

resource "google_dns_managed_zone" "terraformtakehome" {
  name     = "terraformtakehome"
  dns_name = "terraform.takehome."
}

resource "google_dns_record_set" "terraformtakehome" {
  managed_zone = google_dns_managed_zone.terraformtakehome.name

  name    = "www.${google_dns_managed_zone.terraformtakehome.dns_name}"
  type    = "A"
  rrdatas = ["${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"]
  ttl     = 300
}

output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
