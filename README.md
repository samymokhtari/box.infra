# Box Infrastructure
Box project infrastructure hosted on Google Cloud Platform

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_instance.default](https://registry.terraform.io/providers/hashicorp/google/5.4.0/docs/resources/compute_instance) | resource |
| [google_compute_instance_iam_member.gce-compute](https://registry.terraform.io/providers/hashicorp/google/5.4.0/docs/resources/compute_instance_iam_member) | resource |
| [google_compute_network.vpc_network](https://registry.terraform.io/providers/hashicorp/google/5.4.0/docs/resources/compute_network) | resource |
| [google_project_service.cloudresourcemanager](https://registry.terraform.io/providers/hashicorp/google/5.4.0/docs/resources/project_service) | resource |
| [google_project_service.cloudrun](https://registry.terraform.io/providers/hashicorp/google/5.4.0/docs/resources/project_service) | resource |
| [google_project_service.iam](https://registry.terraform.io/providers/hashicorp/google/5.4.0/docs/resources/project_service) | resource |
| [google_service_account.sa](https://registry.terraform.io/providers/hashicorp/google/5.4.0/docs/resources/service_account) | resource |
| [google_service_account_iam_member.gce-account-iam](https://registry.terraform.io/providers/hashicorp/google/5.4.0/docs/resources/service_account_iam_member) | resource |
| [google_storage_bucket.default](https://registry.terraform.io/providers/hashicorp/google/5.4.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.gce-storage](https://registry.terraform.io/providers/hashicorp/google/5.4.0/docs/resources/storage_bucket_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_storage"></a> [bucket\_storage](#input\_bucket\_storage) | Bucket Storage Name | `string` | `"box-files"` | no |
| <a name="input_compute_instance_name"></a> [compute\_instance\_name](#input\_compute\_instance\_name) | Compute Instance Name | `string` | `"vm-sql"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region GCP | `string` | `"europe-west1"` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH Public Key | `string` | n/a | yes |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | SSH User | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC Name | `string` | `"vpc"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->