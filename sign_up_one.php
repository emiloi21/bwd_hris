<!DOCTYPE html>
<html lang="en">
  <?php
  include('dbcon.php');
  include('header.php');
  ?>
  
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');

    :root {
      /* BWD Brand Colors */
      --bwd-primary: #0056b3; 
      --bwd-accent: #00b4d8;
      --text-dark: #2b2b2b;
      --text-muted: #8d97ad;
    }
    
    body {
      background: linear-gradient(-45deg, #0056b3, #00b4d8, #0077b6, #03045e);
      background-size: 400% 400%;
      animation: gradientBG 15s ease infinite;
      min-height: 100vh;
      font-family: 'Poppins', sans-serif;
      margin: 0;
      overflow-x: hidden;
    }

    @keyframes gradientBG {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    .login-page {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 20px;
    }

    /* Glassmorphism Card */
    .form-inner {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(15px);
      -webkit-backdrop-filter: blur(15px);
      padding: 50px 45px;
      border-radius: 24px;
      box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
      width: 100%;
      max-width: 450px;
      margin: auto;
      transform: translateY(30px);
      opacity: 0;
      animation: slideUpFade 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }

    @keyframes slideUpFade {
      to {
        transform: translateY(0);
        opacity: 1;
      }
    }

    .logo-container {
      margin-bottom: 20px;
    }

    /* Removed the drop-shadow and hover effects so the logo displays cleanly */
    .logo-container img {
      width: 85px;
      height: auto;
    }

    .brand-text {
      font-size: 1.4rem;
      font-weight: 700;
      line-height: 1.2;
      color: var(--text-dark);
      margin-bottom: 5px;
    }

    .brand-text .text-primary {
      color: var(--bwd-primary) !important;
    }

    .sub-brand {
      font-size: 0.8rem;
      font-weight: 500;
      color: var(--text-muted);
      margin-bottom: 20px;
      letter-spacing: 1px;
      text-transform: uppercase;
    }

    .step-indicator {
      display: inline-block;
      background: rgba(0, 86, 179, 0.1);
      color: var(--bwd-primary);
      padding: 6px 15px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 600;
      margin-bottom: 35px;
      letter-spacing: 0.5px;
    }

    /* Floating Material Inputs */
    .form-group-material {
      position: relative;
      margin-bottom: 30px;
    }

    .input-material {
      width: 100%;
      border: none;
      border-bottom: 2px solid #e9ecef;
      padding: 10px 0;
      background: transparent;
      outline: none;
      transition: border-color 0.3s;
      font-size: 0.95rem;
      color: var(--text-dark);
      font-family: inherit;
    }

    .input-material:focus {
      border-bottom-color: var(--bwd-primary);
    }

    .label-material {
      position: absolute;
      top: 10px;
      left: 0;
      color: #adb5bd;
      font-size: 0.95rem;
      transition: 0.3s ease all;
      pointer-events: none;
    }

    .input-material:focus ~ .label-material,
    .input-material:valid ~ .label-material {
      top: -18px;
      font-size: 0.75rem;
      font-weight: 600;
      color: var(--bwd-primary);
      letter-spacing: 0.5px;
    }

    .help-link {
      display: block;
      font-size: 0.75rem;
      color: var(--text-muted);
      margin-top: 8px;
      text-decoration: none;
      transition: color 0.3s;
    }

    .help-link:hover {
      color: var(--bwd-primary);
    }

    /* Solid Button Enhancements - No Gradients */
    .button-group {
      display: flex;
      flex-direction: row;
      gap: 15px;
      margin-top: 40px;
    }

    .btn-modern {
      border-radius: 12px;
      padding: 14px 20px;
      font-weight: 600;
      letter-spacing: 1px;
      width: 50%;
      text-transform: uppercase;
      font-size: 0.85rem;
      cursor: pointer;
      font-family: inherit;
      text-align: center;
      text-decoration: none;
      transition: background-color 0.2s; /* Simple color fade only */
    }

    .btn-primary-custom {
      background-color: var(--bwd-primary);
      border: none;
      color: #fff;
    }

    .btn-primary-custom:hover {
      background-color: #004494; /* Simple darker blue on hover */
      color: #fff;
    }
    
    .btn-outline-custom {
      background-color: #f8f9fa;
      border: 1px solid #ced4da;
      color: #495057;
    }

    .btn-outline-custom:hover {
      background-color: #e2e6ea;
      color: #212529;
    }

    /* Copyright Text below the card */
    .copyrights {
      margin-top: 30px;
      font-size: 0.8rem;
      color: rgba(255, 255, 255, 0.7);
    }
    
    .copyrights a {
      color: #fff;
      font-weight: 600;
      text-decoration: none;
    }

    .copyrights a:hover {
      text-decoration: underline;
    }
  </style>
  
  <body>
    <div class="page login-page">
      
      <!-- Glassmorphism Card -->
      <div class="form-inner text-center">
        
        <!-- Logo & Header -->
        <div class="logo-container">
          <img src="img/<?php echo isset($sf_row['logo']) ? $sf_row['logo'] : 'default-logo.png'; ?>" alt="BWD Logo">
        </div>
        
        <div class="brand-text">
          <span>BINALBAGAN</span> <strong class="text-primary">WATER DISTRICT</strong>
        </div>
        <p class="sub-brand">Human Resource Information System</p>
        
        <div class="step-indicator">Account Setup - Step 1 of 2</div>
        
        <!-- Sign Up Form Step 1 -->
        <form method="POST" action="sign_up_two.php" class="text-left form-validate">
          
          <div class="form-group-material">
            <input id="fname" type="text" name="fname" required data-msg="Please enter your first name" class="input-material">
            <label for="fname" class="label-material">First Name</label>
          </div>
          
          <div class="form-group-material">
            <input id="lname" type="text" name="lname" required data-msg="Please enter your last name" class="input-material">
            <label for="lname" class="label-material">Last Name</label>
          </div>
          
          <div class="form-group-material">
            <input id="personnel-id-code" type="text" name="personnel_id_code" required data-msg="Please enter your Personnel ID Code" class="input-material">
            <label for="personnel-id-code" class="label-material">Personnel ID Code</label>
            <a href="#" title="Get your Personnel ID Code from the HR office or system administrator..." class="help-link">
              <i class="fa fa-question-circle"></i> What is a <strong>Personnel ID Code</strong>?
            </a>
          </div>
          
          <div class="button-group">
            <a href="index.php" class="btn-modern btn-outline-custom">Cancel</a>
            <button type="submit" name="stepOneNxt" class="btn-modern btn-primary-custom">Next</button>
          </div>
          
        </form> 
      </div>

      <!-- Copyright Placed Outside the Card -->
      <div class="copyrights text-center">
        <p>Developed by <a href="https://web.facebook.com/aqsijmel" target="_blank">Emiloi</a></p>
      </div>

    </div>

    <?php include('scripts_files.php'); ?>
    
  </body>
</html>