# frozen_string_literal: true

creds = Aws::Credentials.new(Rails.application.secrets.aws_access_key, Rails.application.secrets.aws_secret_key)
Aws.config.update(region: "us-east-1", credentials: creds)
