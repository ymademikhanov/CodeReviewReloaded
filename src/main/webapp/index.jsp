<!DOCTYPE html>
<html>
<head>
    <title>Login/Register</title>
    <meta charset="UTF-8">

    <!-- JQuery -->
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>

    <!-- Bootstrap -->
    <link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css"
          rel="stylesheet">

    <!--  Custom style -->
    <link href="resources/login.css" rel="stylesheet">
</head>

<body>

<div id="welcome_page_background">
    <div id="login_div">
        <h3> Login/Register</h3>
        <form id="login" class="form-signin" >
            <input id="loginEmail" class="form-control" placeholder="E-mail" style="margin-top:2px;">
            <input id="loginPassword" class="form-control" type="password" placeholder="Password" style="margin-top:2px;">
            <p id = "warningLogin" class="help-block"></p>
        </form>

        <form id="register" class="form-signin" style="display: none;">
            <input id="firstname" class="form-control" placeholder="First name" name="first_name" style="margin-top:2px;">
            <p id = "firstNameWarning" class="help-block">Please enter your first name</p>
            <input id="lastname" class="form-control" placeholder="Last name" name="last_name" style="margin-top:2px;">
            <p id = "lastNameWarning" class="help-block">Please enter your last name</p>
            <input id="registerEmail" class="form-control" placeholder="E-mail" name="email" style="margin-top:2px;">
            <p id = "emailWarning" class="help-block">Enter any valid e-mail</p>
            <input id="registerPassword" class="form-control" type="password" name = "password" placeholder="Password" style="margin-top:2px;">
            <p id = "passwordWarning" class="help-block">Password length should be more than 6 symbols</p>
            <input id="registerPasswordConfirm" class="form-control" type="password" name = "password" placeholder="Password" style="margin-top:2px;">
            <p id = "passwordConfirmWarning" class="help-block">Passwords should match</p>
            <p id = "warningRegistration" class="help-block"> no result </p>
        </form>
        <button id = "submitButton" class="btn btn-lg btn-primary btn-block" type="button" style="margin-top: 5px">Login</button>
        <div id = "switcher_div">
            <a href="#" id="switcher"> Register </a>
        </div>
    </div>
</div>

</body>

</html>

<script>
    const form_modes = ["Register", "Login"];
    const form_display_mode = ["none", "block"];
    const LOGIN = 0;
    const REGISTER = 1;
    var current_mode = LOGIN;
    $("#switcher").click(function() {
        $("#login").css("display", form_display_mode[current_mode]);
        $("#register").css("display", form_display_mode[current_mode ^ 1]);
        $("#submitButton").text(form_modes[current_mode]);
        $("#switcher").text(form_modes[current_mode ^ 1]);
        current_mode ^= 1;
    })
    function sendAuthorizeRequest(url, params) {
        var result;
        $.ajax ({
            type: "POST",
            url: url,
            contentType: 'application/json',
            async: false,
            data: JSON.stringify(params),
            success: function (response) {
                if (response.status === 200) {
                    $("#warningLogin").text("Successful login");
                } else {
                    $("#warningLogin").text("Invalid username or password");
                }
            }
        });
        return result;
    }
    function validAuthorizeParams(params) {
        var errors = [false, false, false, false, false];
        if ("firstname" in params) {
            if (params["firstname"].length > 30) {
                errors[0] = true;
            }
        }
        if ("lastname" in params) {
            if (params["lastname"].length > 30) {
                errors[1] = true;
            }
        }
        if ("password" in params) {
            if (params["password"].length > 30) {
                errors[2] = true;
            }
        }
        if ("password2" in params) {
            if (params["password2"] !== params["password"]) {
                errors[3] = true;
            }
        }
        if ("username" in params) {
            if (params["username"].search("@") === -1 || params["username"].length > 30) {
                errors[4] = true;
            }
        }
        if (!errors[0] && !errors[1] && !errors[2] && !errors[3] && !errors[4])
            return true;
        return errors;
    }
    $("#submitButton").click(function() {
        var url;
        var params = {};
        if (current_mode === LOGIN) {
            params["username"] = $("#loginEmail").val();
            params["password"] = $("#loginPassword").val();
            $("warningLogin").text(sendAuthorizeRequest("/services/login", params));
        } else {
            params["firstname"] = $("#firstname").val();
            params["lastname"] = $("#lastname").val();
            params["username"] = $("#registerEmail").val();
            params["password"] = $("#registerPassword").val();
            params["password2"] = $("#registerPasswordConfirm").val();
            var validationResult = validAuthorizeParams(params);
            if (validationResult === true) {
                $("#warningRegistration").text("valid");
                params.remove("password2");
                sendAuthorizeRequest("/register", params);
            } else {
                console.log(validationResult);
                if (validationResult[0])
                    $("#firstNameWarning").text("Firstname length should be less than 30 characters");
                if (validationResult[1])
                    $("#lastNameWarning").text("Lastname length should be less than 30 characters");
                if (validationResult[2])
                    $("#passwordWarning").text("Password length should be less than 30 characters");
                if (validationResult[3])
                    $("#passwordConfirmWarning").text("Passwords don't match");
                if (validationResult[4])
                    $("#emailWarning").text("Email should be valid email");
            }
        }
    })
</script>