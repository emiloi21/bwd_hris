<!DOCTYPE html>
<html>

  <?php
  
  include('dbcon.php');
  include('header.php');
  
  ?>
  
  <body>
    <div class="page login-page">
      <div class="container">
        <div class="form-outer text-center d-flex align-items-center">
          <div class="form-inner">
            
            <div class="logo text-uppercase">

            <div class="row">
              <div class="col-12"><img src="img/<?php echo $sf_row['logo']; ?>" style="width: 100px; height: auto;" alt=""></div>

              <!--div class="col-6"><img src="img/one-hinoba-an.png" style="width: 200px; height: auto;" alt=""></div-->

            </div>

            <span>BINALBAGAN</span> <strong class="text-primary">WATER DISTRICT</strong></div>
            <p><strong>HUMAN RESOURCE INFORMATION SYSTEM</strong> [ ver. 1.0 ]
            
           
            </p>
            <form method="POST" action="login.php" class="text-left form-validate">
              <div class="form-group-material">
                <input id="login-username" type="text" name="username" required data-msg="Please enter your username" class="input-material">
                <label for="login-username" class="label-material">Username</label>
              </div>
              <div class="form-group-material">
                <input id="login-password" type="password" name="password" required data-msg="Please enter your password" class="input-material">
                <label for="login-password" class="label-material">Password</label>
              </div>
              
              <div class="form-group text-center">
               
              &nbsp;<a style="color: white;" href="refLastTag.php" class="btn btn-info">Log Keeper</a>
              
              &nbsp;<button id="login" class="btn btn-primary">Login</button>
              
                <!-- This should be submit button but I replaced it with <a> for demo purposes -->
              </div>
            </form><a data-toggle="modal" data-target="#fua" href="#" class="forgot-pass">Forgot login data?</a><small>Account Setup? Click</small> <a href="sign_up_one.php" class="signup"><strong>here</strong></a>.
          </div>
          <div class="copyrights text-center">
            <p>Design by <a href="https://bootstrapious.com" class="external">Bootstrapious</a> &middot; Developed by <a href="https://bootstrapious.com" class="external">Emiloi</a></p>
            <!-- Please do not remove the backlink to us unless you support further theme's development at https://bootstrapious.com/donate. It is part of the license conditions. Thank you for understanding :)-->
          </div>
        </div>
      </div>
    </div>
 
 
    <?php include('forgotUserAccount_modal.php'); ?>
    
    <?php include('scripts_files.php'); ?>
    
  </body>
</html>