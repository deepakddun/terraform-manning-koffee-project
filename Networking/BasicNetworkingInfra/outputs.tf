output "vpc" {
  value = {
    vpc_id                = aws_vpc.koffee_vpc.id
    subnet_id_public      = [aws_subnet.publicA.id, aws_subnet.publicB.id, aws_subnet.publicC.id]
    subnet_id_private_app = [aws_subnet.AppA.id, aws_subnet.AppB.id, aws_subnet.AppC.id]
    subnet_id_private_db  = [aws_subnet.DbA.id, aws_subnet.DbB.id, aws_subnet.DbC.id]
  }
}

output "sg" {
  value = {
    lb_sg  = aws_security_group.load_balancer_sg.id
    ecs_sg = aws_security_group.aws_ecs_security_group.id
  }
}