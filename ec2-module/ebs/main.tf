# Create EBS Volumes in Multiple Availability Zones
resource "aws_ebs_volume" "my_ebs_volume" {
  count             = var.az_count
  availability_zone = var.availability_zones[count.index]
  size              = var.ebs_size

  tags = {
    Name = "my_ebs_volume_${count.index + 1}"
  }
}

# Attach EBS Volumes to EC2 Instances
resource "aws_volume_attachment" "ebs_attachment" {
  count       = var.instance_count
  device_name = "/dev/sdh"

  volume_id   = aws_ebs_volume.my_ebs_volume[count.index % var.az_count].id
  instance_id = aws_instance.Test-EC2[count.index].id
}
