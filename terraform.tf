terraform {
    backend "s3" {
        bucket= "project-bucket090"
        key = "backend/terraform.tfstate"
        region = "us-east-2"
        access_key = "AKIA3ACNW5PKF6H73EQ3"
     secret_key = "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"
    }
}
