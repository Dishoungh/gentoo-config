# Login Shell Configurations
if status is-login
	test -f /etc/profile.env ; and source /etc/profile.env ; and source ~/.profile
end

# Interactive Shell Configurations
if status is-interactive
	# Alias Declarations
	alias sudo="doas"
	alias shutdown="doas poweroff"
	alias reboot="doas reboot"
	alias poweroff="doas poweroff"

	# Source Declarations
end
