provider "google" {
credentials = "${file("credentials.json")}"
project = "takehome-384210"
region = "us-east1"
}
