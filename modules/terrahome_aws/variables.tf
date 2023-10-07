variable "user_uuid" {
    description = "The UUID of the user"
    type = string

    validation {
        condition = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}", var.user_uuid))
        error_message = "The user_uuid value it not a valid UUID."
    }
}

#variable "bucket_name" {
#  type        = string
#  description = "Name of the AWS S3 bucket"
#
#  validation {
#    condition     = can(regex("^([a-zA-Z0-9.-]{3,63})$", var.bucket_name))
#    error_message = "Invalid AWS S3 bucket name. It must be between 3 and 63 characters long and only contain alphanumeric characters, hyphens, or periods."
#  }
#}

variable "public_path" {
  description = "The file path for the public directory"
  type        = string
}

variable "content_version" {
  description = "Content version (positive integer starting at 1)"
  type        = number

  validation {
    condition     = var.content_version >= 1 && ceil(var.content_version) == floor(var.content_version)
    error_message = "Content version must be a positive integer starting at 1."
  }
}