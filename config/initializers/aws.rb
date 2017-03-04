# frozen_string_literal: true

creds = Aws::Credentials.new(ENV["AWS_ACCESS_KEY"], ENV["AWS_SECRET_KEY"])
Aws.config.update(region: "us-east-1", credentials: creds)
