output "jenkins-url" {
    value = join ("",["https://", aws_instance.Jenkins.public_dns,":","8080"])

}