/*resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  # ...otras configuraciones de EC2...
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_s3_access_role.name
}
*/