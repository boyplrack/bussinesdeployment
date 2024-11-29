terraform {
  backend "s3" {
    bucket         = "estadoremotobussiness"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
  }
}
