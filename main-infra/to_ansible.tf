#########################################
# 1️⃣ Generate group vars for Ansible
#########################################
resource "local_file" "ansible_vars" {
  content = templatefile("${path.module}/templates/ansible_vars.tpl", {
    s3_bucket_name          = module.s3_static.bucket_name
    s3_bucket_url           = module.s3_static.bucket_url
    db_endpoint             = module.rdb.db_endpoint
    db_username             = module.rdb.db_username
    db_password             = module.rdb.db_password
    db_name                 = module.rdb.db_name
    backend_private_ip      = module.ec2.private_ip
    reverse_proxy_public_ip = module.ec2.public_ip
  })
  filename = "${path.module}/../ansible/group_vars/all/from_terraform.yml"
}


#########################################
# 2️⃣ Generate inventory file for Ansible
#########################################
resource "local_file" "ansible_inventory" {
  content = <<-EOT
    [reverse-proxy]
    ${module.ec2.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/terraform-key

    [backend]
    ${module.ec2.private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/terraform-key ansible_ssh_common_args='-o ProxyJump=ubuntu@${module.ec2.public_ip}'

    [database]
    ${module.rdb.db_endpoint} ansible_connection=local
  EOT

  filename = "${path.module}/../ansible/inventory.ini"
}
