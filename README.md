# sudoblark.terraform.module.aws.sns
Terraform module to create N number of SNS topics with appropriate subscriptions. - repo managed by sudoblark.terraform.github

## Developer documentation
The below documentation is intended to assist a developer with interacting with the Terraform module in order to add,
remove or update functionality.

### Pre-requisites
* terraform_docs

```sh
brew install terraform_docs
```

* tfenv
```sh
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
```

* Virtual environment with pre-commit installed

```sh
python3 -m venv venv
source venv/bin/activate
pip install pre-commit
```
### Pre-commit hooks
This repository utilises pre-commit in order to ensure a base level of quality on every commit. The hooks
may be installed as follows:

```sh
source venv/bin/activate
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

# Module documentation
The below documentation is intended to assist users in utilising the module, the main thing to note is the
[data structure](#data-structure) section which outlines the interface by which users are expected to interact with
the module itself, and the [examples](#examples) section which has examples of how to utilise the module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.63.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.66.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lambda_permission.allow_lambda_execution_from_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_sns_topic.topics](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.subscriptions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_iam_policy_document.topic_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Name of the application utilising the resource resource. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Which environment this is being instantiated in. | `string` | n/a | yes |
| <a name="input_raw_sns_topics"></a> [raw\_sns\_topics](#input\_raw\_sns\_topics) | Data structure<br>---------------<br>A list of dictionaries, where each dictionary has the following attributes:<br><br>REQUIRED<br>---------<br>- suffix                : Suffix for the topic, will also be used as a unified index for Terraform resources.<br><br>- iam\_policy\_statements : A list of dictionaries where each dictionary is an IAM statement defining topic policy permissions.<br>-- Each dictionary in this list must define the following attributes:<br>--- sid: Friendly name for the policy, no spaces or special characters allowed<br>--- actions: A list of IAM actions the state machine is allowed to perform<br>--- resources: Which resource(s) the state machine may perform the above actions against<br>--- conditions    : An OPTIONAL list of dictionaries, which each defines:<br>---- test         : Test condition for limiting the action<br>---- variable     : Value to test<br>---- values       : A list of strings, denoting what to test for<br>--- principals    : An list of dictionaries, which each defines:<br>---- type         : A string defining what type the principle(s) is/are<br>---- identifiers  : A list of strings, where each string is an allowed principle<br><br>- subscriptions          : A list of dictionaries, where each dictionary defines:<br>-- endpoint             : Actual endpoint to deliver to, see constraints for more information.<br>-- name                 : Friendly name for the endpoint, used for unique indexing in Terraform.<br>-- protocol             : Determines the subscription type, permissible types are: email, lambda<br><br>Constraints<br>---------<br>- if endpoints.protocol == lambda then:<br>-- endpoint must be ARN of a lambda function<br>-- name must be name of a lambda function<br>- if endpoints.protocol == email, then endpoint must be an email address<br><br>- Only lambda and email endpoints.protocol values are supported | <pre>list(<br>    object({<br>      suffix = string,<br>      iam_policy_statements = list(<br>        object({<br>          sid       = string,<br>          actions   = list(string),<br>          resources = list(string),<br>          conditions = optional(list(<br>            object({<br>              test : string,<br>              variable : string,<br>              values = list(string)<br>            })<br>          ), [])<br>          principals = list(<br>            object({<br>              type        = string,<br>              identifiers = list(string)<br>            })<br>          )<br>        })<br>      ),<br>      subscriptions = list(<br>        object({<br>          endpoint : string,<br>          name : string,<br>          protocol : string<br>        })<br>      ),<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Data structure
```
Data structure
---------------
A list of dictionaries, where each dictionary has the following attributes:

REQUIRED
---------
- suffix                : Suffix for the topic, will also be used as a unified index for Terraform resources.

- iam_policy_statements : A list of dictionaries where each dictionary is an IAM statement defining topic policy permissions.
-- Each dictionary in this list must define the following attributes:
--- sid: Friendly name for the policy, no spaces or special characters allowed
--- actions: A list of IAM actions the state machine is allowed to perform
--- resources: Which resource(s) the state machine may perform the above actions against
--- conditions    : An OPTIONAL list of dictionaries, which each defines:
---- test         : Test condition for limiting the action
---- variable     : Value to test
---- values       : A list of strings, denoting what to test for
--- principals    : An list of dictionaries, which each defines:
---- type         : A string defining what type the principle(s) is/are
---- identifiers  : A list of strings, where each string is an allowed principle

- subscriptions          : A list of dictionaries, where each dictionary defines:
-- endpoint             : Actual endpoint to deliver to, see constraints for more information.
-- name                 : Friendly name for the endpoint, used for unique indexing in Terraform.
-- protocol             : Determines the subscription type, permissible types are: email, lambda

Constraints
---------
- if endpoints.protocol == lambda then:
-- endpoint must be ARN of a lambda function
-- name must be name of a lambda function
- if endpoints.protocol == email, then endpoint must be an email address

- Only lambda and email endpoints.protocol values are supported
```

## Examples
See `examples` folder for an example setup.
