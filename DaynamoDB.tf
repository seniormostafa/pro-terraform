resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "look-state-file"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}