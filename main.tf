
#Create the VPC
 
 
resource "aws_vpc" "Main" {                
   cidr_block       = var.main_vpc_cidr     
   instance_tenancy = "default"
   tags={
   "Name" : "project_VPC"
   }
 }
 
#Create Internet Gateway and attach it to VPC
 
 
resource "aws_internet_gateway" "IGW" {       
    vpc_id =  aws_vpc.Main.id                  
 }

#creat EC2
resource "aws_instance" "App" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.publicsubnets.id
  
  
  associate_public_ip_address = "true"
  
  tags = {
    Name           = "App-instance"
  }
}

resource "aws_instance" "DB" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.privatesubnets.id
  
  
  associate_public_ip_address = "false"
  
  tags = {
    Name           = "DB-instance"
  }
} 

#Create a Public Subnets.


resource "aws_subnet" "publicsubnets" {    # Creating Public Subnets
   vpc_id =  aws_vpc.Main.id
   cidr_block = "${var.public_subnets}"        # CIDR block of public subnets
   
   tags={
     "Name":"Public_Subnet"
   }
 }
 

# Create a Private Subnet                   # Creating Private Subnets
 
 
 
resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.Main.id
   cidr_block = "${var.private_subnets}"          # CIDR block of private subnets
   tags={
   "Name":"Private_Subnet"
   }
 }

#Route table for Public Subnet's
 
resource "aws_route_table" "PublicRT" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.Main.id
    route {
      cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
      gateway_id = aws_internet_gateway.IGW.id
     }
 }
 
# Route table for Private Subnet's


resource "aws_route_table" "PrivateRT" {    # Creating RT for Private Subnet
   vpc_id = aws_vpc.Main.id
   route {
   cidr_block = "0.0.0.0/0"             # Traffic from Private Subnet reaches Internet via NAT Gateway
   nat_gateway_id = aws_nat_gateway.NATgw.id
   }
 }
 
# Route table Association with Public Subnet's
 
 
resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }
 
# Route table Association with Private Subnet's

resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
 }
# Create public ip

resource "aws_eip" "nateIP" {
   vpc   = true
 }
 
 
# Creating the NAT Gateway using subnet_id and allocation_id
 
resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.publicsubnets.id
 }