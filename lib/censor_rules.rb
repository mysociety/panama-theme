#!/bin/env ruby
#encoding: utf-8

# if not already created, make a CensorRule that hides personal information
regexp = '={67}\s*\n(?:[^\n]*?#[^\n]*?: ?[^\n]*\n){3,10}[^\n]*={67}'
rule = CensorRule.find_by_text(regexp)
if rule.nil?
    Rails.logger.info("Creating new censor rule: /#{regexp}/")
    CensorRule.create!(:text => regexp,
                       :allow_global => true,
                       :replacement => '[redacted]',
                       :regexp => true,
                       :last_edit_editor => 'system',
                       :last_edit_comment => 'Added automatically by panamatheme')

    CensorRule
end
