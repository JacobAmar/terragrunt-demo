module "eks" {
  source                           = "terraform-aws-modules/eks/aws"
  version                          = "19.13.1"
  cluster_name                     = "${var.environment}-eks"
  cluster_endpoint_public_access   = true
  cluster_endpoint_private_access  = false
  vpc_id                           = var.vpc_id
  subnet_ids                       = var.subnet_ids
  create_iam_role                  = true
  iam_role_name                    = "${var.environment}-eks-iam-role"
  self_managed_node_groups         = var.self_managed_node_groups
  create_aws_auth_configmap        = true
  manage_aws_auth_configmap        = false
  node_security_group_additional_rules = {
    node_to_node_communication = {
      protocol          = "-1"
      from_port         = 0
      to_port           = 0
      type              = "ingress"
      self              = true
    }
  }
  self_managed_node_group_defaults = {
    create_iam_role              = true
    post_bootstrap_user_data     = <<-EOT
        TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
        INSTANCEID=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id`
        aws ec2 modify-instance-attribute --instance-id $INSTANCEID --no-source-dest-check --region ${var.region}
        sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
        sudo systemctl enable amazon-ssm-agent
        sudo systemctl start amazon-ssm-agent
      EOT
    iam_role_name                = "${var.environment}-eks-ng-iam-role"
    iam_role_additional_policies = {
      calico = aws_iam_policy.calico.arn,
      ssm    = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}