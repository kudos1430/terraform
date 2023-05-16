resource "aws_s3_bucket" "bucket" {
  bucket = "project-bucket09"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_object" "upload" {
  bucket = aws_s3_bucket.bucket.id
 key    = "Course-Certificate_Terraform-Basics-Training-Course_Saqib-Mustafa.pdf"
  source = "C:\\Users\\hamza.nasirmahmood\\Downloads\\Course-Certificate_Terraform-Basics-Training-Course_Saqib-Mustafa.pdf"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  #etag = filemd5("C:\\Users\\hamza.nasirmahmood\\Desktop\\k8s-export")
}
#for multiple 
resource "aws_s3_bucket_object" "upload1" {
  bucket = aws_s3_bucket.bucket.id
  for_each = fileset("C:\\Users\\hamza.nasirmahmood\\Desktop\\s3files","*")
  key    = each.value
  source = "C:\\Users\\hamza.nasirmahmood\\Desktop\\s3files\\${each.value}"

}
