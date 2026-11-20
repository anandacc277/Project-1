#!/bin/bash
set -e

# Update system
yum update -y

# Install Apache web server
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create a simple health check page
cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Web Server</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 50px;
            background-color: #f0f0f0;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        h1 { color: #333; }
        .status { color: green; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Terraform Web Server</h1>
        <p class="status">✓ Server is running successfully</p>
        <p>Instance ID: <code id="instance-id">Loading...</code></p>
        <p>Availability Zone: <code id="az">Loading...</code></p>
        <p>Region: <code id="region">Loading...</code></p>
    </div>
    <script>
        fetch('http://169.254.169.254/latest/meta-data/instance-id')
            .then(r => r.text())
            .then(data => document.getElementById('instance-id').textContent = data);
        fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone')
            .then(r => r.text())
            .then(data => document.getElementById('az').textContent = data);
        fetch('http://169.254.169.254/latest/meta-data/placement/region')
            .then(r => r.text())
            .then(data => document.getElementById('region').textContent = data);
    </script>
</body>
</html>
EOF

# Create a health check endpoint
cat > /var/www/html/health.txt <<'EOF'
OK
EOF

echo "Web server setup complete"
