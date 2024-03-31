<!-- login.cfm -->
<cfparam name="newAccountMessage" default="">
<cfparam name="loginMessage" default="">

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login / Create Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <!-- New Account Form -->
            <div class="col-lg-6">
                <h3>Create New Account</h3>
                <div id="newaccountmessage">
                    <cfoutput>#newAccountMessage#</cfoutput>
                </div>
                <form method="POST" action="?p=login" onsubmit="return validateNewAccount();">
                    <input type="text" name="firstname" required placeholder="First Name" class="form-control mb-2">
                    <input type="text" name="lastname" required placeholder="Last Name" class="form-control mb-2">
                    <input type="email" name="email" required placeholder="Email Address" class="form-control mb-2">
                    <input type="password" id="password" name="password" required placeholder="Password" class="form-control mb-2">
                    <input type="password" id="confirmPassword" required placeholder="Confirm Password" class="form-control mb-2">
                    <button class="btn btn-warning" type="submit">Make Account</button>
                </form>
            </div>

            <!-- Login Form -->
            <div class="col-lg-6">
                <h3>Login</h3>
                <div id="loginmessage">
                    <cfoutput>#loginMessage#</cfoutput>
                </div>
                <form method="POST" action="?p=login">
                    <input type="email" name="loginemail" required placeholder="Email Address" class="form-control mb-2">
                    <input type="password" name="loginpass" required placeholder="Password" class="form-control mb-2">
                    <button class="btn btn-primary" type="submit">Login</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function validateNewAccount() {
            let originalPassword = document.getElementById('password').value;
            let confirmPassword = document.getElementById('confirmPassword').value;
            if(originalPassword !== '' && originalPassword === confirmPassword) {
                return true; // Form is valid, allow submission
            } else {
                document.getElementById('newaccountmessage').innerHTML = "Passwords do not match.";
                return false; // Prevent form submission
            }
        }
    </script>
</body>
</html>
