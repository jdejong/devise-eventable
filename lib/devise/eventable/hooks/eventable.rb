# frozen_string_literal: true

Warden::Manager.after_authentication do |record, warden, options|
  Devise.fire_event(:login, { record: record, warden: warden, options: options } )
end

Warden::Manager.after_set_user except: :fetch do |record, warden, options|

end

Warden::Manager.before_failure do |env, options|
  Devise.fire_event(:login_failure, { env: env, options: options } )
end

Warden::Manager.before_logout do |record, warden, options|
  Devise.fire_event(:logout, { record: record, warden: warden, options: options } ) if record
end


#
#
#
# strategy: detect_strategy(env["warden"]),
#     scope: opts[:scope].to_s,
#     identity: AuthTrail.identity_method.call(request, opts, nil),
#     success: false,
#     request: request,
#     failure_reason: opts[:message].to_s
# user: user