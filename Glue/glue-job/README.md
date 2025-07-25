# glue-job

Terraform module to provision an AWS Glue Job, supporting flexible configuration of job parameters, execution settings, notifications, and default arguments.

## Features

- Conditional resource creation via `enabled` flag
- Support for Spark (`glueetl`) and Python Shell (`pythonshell`) jobs
- Optional execution and notification properties
- Customizable `default_arguments` and `non_overridable_arguments`
- Outputs for Glue Job ID, name, and ARN

---

## Usage

```hcl
module "iam_role" {
  source  = "./iam-role"
  version = "0.16.2"

  principals = {
    "Service" = ["glue.amazonaws.com"]
  }

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  ]

  policy_document_count = 0
  policy_description    = "Policy for AWS Glue with access to EC2, S3, and Cloudwatch Logs"
  role_description      = "Role for AWS Glue with access to EC2, S3, and Cloudwatch Logs"

  context = module.this.context
}
```
```hcl
module "s3_bucket_job_source" {
  source  = "/s3-bucket"
  version = "2.0.3"

  acl                          = "private"
  versioning_enabled           = false
  force_destroy                = true
  allow_encrypted_uploads_only = true
  allow_ssl_requests_only      = true
  block_public_acls            = true
  block_public_policy          = true
  ignore_public_acls           = true
  restrict_public_buckets      = true

  context = module.this.context
}
```
```hcl
module "glue_job" {
  source = "./modules/glue-job"

  enabled         = true
  job_name        = "geo_processor"
  job_description = "Glue Job for processing geo data"
  role_arn        = module.iam_role.arn
  glue_version    = "3.0"

  default_arguments = {
    "--TempDir"           = "s3://my-temp-dir/tmp/"
    "--additional-python-modules" = "pandas==1.3.3"
  }

  non_overridable_arguments = {}

  worker_type       = "Standard"
  number_of_workers = 2
  max_retries       = 2
  timeout           = 20

  command = {
    name            = "glueetl"
    script_location = format("s3://%s/scripts/geo.py", module.s3_bucket_job_source.bucket_id)
    python_version  = 3
  }

  execution_property = {
    max_concurrent_runs = 1
  }

  notification_property = {
    notify_delay_after = 5
  }

  tags = {
    Environment = "dev"
    Owner       = "data-team"
  }
}
```

# INPUTS
| Name                        | Type   | Description                                                      | Default        |
| --------------------------- | ------ | ---------------------------------------------------------------- | -------------- |
| `enabled`                   | bool   | Enable or disable resource creation                              | `true`         |
| `job_name`                  | string | Name of the Glue Job                                             | `null`         |
| `job_description`           | string | Optional job description                                         | `null`         |
| `role_arn`                  | string | IAM Role ARN for the Glue job                                    | **(required)** |
| `glue_version`              | string | Glue version (`"2.0"`, `"3.0"`, etc.)                            | **(required)** |
| `worker_type`               | string | Type of worker (`Standard`, `G.1X`, `G.2X`)                      | `null`         |
| `number_of_workers`         | number | Number of workers                                                | `null`         |
| `max_capacity`              | number | Maximum capacity in DPUs (optional, exclusive with workers)      | `null`         |
| `max_retries`               | number | Maximum number of retries on job failure                         | `null`         |
| `timeout`                   | number | Job timeout in minutes                                           | `null`         |
| `connections`               | list   | List of connection names for the job                             | `[]`           |
| `default_arguments`         | map    | Default arguments passed to the job                              | `{}`           |
| `non_overridable_arguments` | map    | Arguments that cannot be overridden                              | `{}`           |
| `security_configuration`    | string | Name of Glue Security Configuration                              | `null`         |
| `command`                   | object | Glue job command block (name, script\_location, python\_version) | **(required)** |
| `execution_property`        | object | Optional block to set max concurrent runs                        | `null`         |
| `notification_property`     | object | Optional block to set notify delay after                         | `null`         |
| `tags`                      | map    | Tags to apply to the Glue Job                                    | `{}`           |


# OUTPUTS

| Name   | Description         |
| ------ | ------------------- |
| `id`   | Glue Job ID         |
| `name` | Glue Job name       |
| `arn`  | ARN of the Glue Job |

# Example Default Arguments
To pass arguments to your Glue script:

```hcl
default_arguments = {
  "--TempDir"           = "s3://your-temp-dir/tmp/"
  "--job-language"      = "python"
  "--additional-python-modules" = "pandas==1.3.3,numpy"
}
```

# Notes
* Use glueetl for Spark jobs and pythonshell for lightweight scripts.
* Either max_capacity or number_of_workers + worker_type must be used (not both).
* Use enabled = false to disable job creation in specific environments.

## License
Apache 2.0 © 2025