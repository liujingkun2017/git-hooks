#!/opt/gitlab/embedded/bin/ruby
# Fix the PATH so that gitlab-shell can find git-upload-pack and friends.
ENV['PATH'] = '/opt/gitlab/bin:/opt/gitlab/embedded/bin:' + ENV['PATH']

#!/usr/bin/env ruby

# This file was placed here by GitLab. It makes sure that your pushed commits
# will be processed properly.

refs = ARGF.read
key_id  = ENV['GL_ID']
repo_path = Dir.pwd

require_relative '../lib/gitlab_custom_hook'
require_relative '../lib/gitlab_access'

if GitlabAccess.new(repo_path, key_id, refs).exec &&
    GitlabCustomHook.new.pre_receive(refs, repo_path)
  exit 0
else
  # reset GL_ID env since we stop git push here
  ENV['GL_ID'] = nil

  exit 1
end

