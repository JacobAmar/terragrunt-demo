resource "aws_iam_policy" "calico" {
  policy = file("${path.module}/files/ec2_policy.json")
  name   = "calico-ec2-policy"
}