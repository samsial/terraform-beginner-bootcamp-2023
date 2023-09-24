variable "user_uuid" {
    description = "The UUID of the user"
    type = string

validation {
    condition = can(regex("^[0-9a=fA=F]{8}-[0-9a=fA=F]{4}-[0-9a=fA=F]{4}-[0-9a=fA=F]{4}-[0-9a=fA=F]{12}))
    error_message = "The user_uuid value it not a valid UUID"
}