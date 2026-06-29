<!DOCTYPE html>
<html>
  <?php
  include('dbcon.php');
  include('header.php');
  ?>
  
  <style>
    /* Modern UI Enhancements */
    :root {
      /* Change this hex code to match the exact blue of the BWD logo */
      --bwd-primary: #0056b3; 
      --bwd-secondary: #17a2b8;
    }
    
    body {
      background: linear-gradient(135deg, #f4f7f6 0%, #e0e8e5 100%);
      min-height: 100vh;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .login-page {
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 20px;
    }

    .form-inner {
      background: #ffffff;
      padding: 45px 40px;
      border-radius: 16px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
      width: 100%;
      max-width: 450px;
      margin: auto;
      transition: transform 0.3s ease;
    }

    .logo-container {
      margin-bottom: 20px;
    }

    .logo-container img {
      width: 110px;
      height: auto;
      transition: transform 0.3s ease;
    }

    .logo-container img:hover {
      transform: scale(1.05);
    }

    .brand-text {
      font-size: 1.6rem;
      font-weight: 800;
      letter-spacing: 1px;
      color: #333;
      margin-bottom: 5px;
    }

    .brand-text .text-primary {
      color: var(--bwd-primary) !important;
    }

    .sub-brand {
      font-size: 0.85rem;
      color: #6c757d;
      margin-bottom: 35px;
      letter-spacing: 0.5px;
      text-transform: uppercase;
    }

    /* Floating Material Inputs */
    .form-group-material {
      position: relative;
      margin-bottom: 30px;
    }

    .input-material {
      width: 100%;
      border: none;
      border-bottom: 2px solid #e0e0e0;
      padding: 10px 0;
      background: transparent;
      outline: none;
      transition: border-color 0.3s;
      font-size: 1rem;
      color: #333;
    }

    .input-material:focus {
      border-bottom-color: var(--bwd-primary);
    }

    .label-material {
      position: absolute;
      top: 10px;
      left: 0;
      color: #aaa;
      transition: 0.3s ease all;
      pointer-events: none;
    }

    /* Keeps the label floating when focused or when text is entered (requires the 'required' attribute) */
    .input-material:focus ~ .label-material,
    .input-material:valid ~ .label-material {
      top: -16px;
      font-size: 0.8rem;
      font-weight: 600;
      color: var(--bwd-primary);
    }

    /* Button Enhancements */
    .button-group {
      display: flex;
      justify-content: space-between;
      gap: 15px;
      margin-top: 35px;
      margin-bottom: 25px;
    }

    .btn-modern {
      border-radius: 50px;
      padding: 12px 20px;
      font-weight: 600;
      letter-spacing: 0.5px;
      transition: all 0.3s;
      width: 100%;
      text-transform: uppercase;
      font-size: 0.85rem;
    }

    .btn-primary-custom {
      background-color: var(--bwd-primary);
      border: none;
      color: #fff;
    }

    .btn-primary-custom:hover {
      background-color: #004494; /* Slightly darker shade */
      box-shadow: 0 4px 15px rgba(0, 86, 179, 0.3);
      color: #fff;
    }
    
    .btn-info-custom {
      background-color: var(--bwd-secondary);
      border: none;
      color: #fff;
    }

    .btn-info-custom:hover {
      background-color: #117a8b;
      box-shadow: 0 4px 15px rgba(23, 162, 184, 0.3);
      color: #fff;
    }

    /* Footer Text */
    .footer-links {
      font-size: 0.9rem;
      margin-top: 20px;
    }

    .footer-links a {
      color: var(--bwd-primary);
      text-decoration: none;
      font-weight: 600;
      transition: color 0.3s;
    }

    .footer-links a:hover {
      color: #003d82;
      text-decoration: underline;
    }

    .copyrights {
      margin-top: 30px;
      font-size: 0.8rem;
      color: #888;
    }
    
    .copyrights a {
      color: #666;
    }
  </style>
  
  <body>
    <div class="page login-page">
      <div class="container">
        
        <div class="form-inner text-center">
          <!-- Logo & Header -->
          <div class="logo-container">
            <img src="img/<?php echo $sf_row['logo']; ?>" alt="BWD Logo">
          </div>
          
          <div class="brand-text">
            <span>BINALBAGAN</span> <strong class="text-primary">WATER DISTRICT</strong>
          </div>
          <p class="sub-brand"><strong>Human Resource Information System</strong> [ ver. 1.0 ]</p>
          
          <!-- Login Form -->
          <form method="POST" action="login.php" class="text-left form-validate">
            
            <div class="form-group-material">
              <input id="login-username" type="text" name="username" required data-msg="Please enter your username" class="input-material">
              <label for="login-username" class="label-material">Username</label>
            </div>
            
            <div class="form-group-material">
              <input id="login-password" type="password" name="password" required data-msg="Please enter your password" class="input-material">
              <label for="login-password" class="label-material">Password</label>
            </div>
            
            <div class="button-group">
              <a href="refLastTag.php" class="btn btn-modern btn-info-custom text-white">Log Keeper</a>
              <button type="submit" id="login" class="btn btn-modern btn-primary-custom">Login</button>
            </div>
            
          </form>
          
          <!-- Helper Links -->
          <div class="footer-links">
            <a data-toggle="modal" data-target="#fua" href="#" class="forgot-pass d-block mb-2">Forgot login data?</a>
            <span class="text-muted">Account Setup? Click</span> <a href="sign_up_one.php" class="signup">here</a>.
          </div>
        </div>
        
        <!-- Copyright -->
        <div class="copyrights text-center">
          <p>Design by <a href="https://bootstrapious.com" class="external">Bootstrapious</a> &middot; Developed by <a href="#" class="external">Emiloi</a></p>
        </div>
        
      </div>
    </div>

    <?php include('forgotUserAccount_modal.php'); ?>
    <?php include('scripts_files.php'); ?>
    
  </body>
</html>