<!-- =========================================
         MODERN SIDEBAR SPECIFIC OVERRIDES 
         ========================================= -->
    <style>
        /* Force Sidebar Header to be clean and white */
        .side-navbar .sidenav-header {
            background: #ffffff !important;
            border-bottom: 1px solid #f1f5f9 !important;
            padding: 35px 15px 25px 15px !important;
        }

        /* Profile Image Elevation */
        .side-navbar .sidenav-header-inner img {
            width: 75px !important;
            height: 75px !important;
            background: #ffffff;
            padding: 4px;
            box-shadow: 0 8px 20px rgba(0, 143, 218, 0.15); /* Soft blue shadow */
            border: 2px solid #f8fafc;
            object-fit: contain;
            margin-bottom: 15px;
            transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .side-navbar .sidenav-header-inner img:hover {
            transform: scale(1.08) translateY(-3px);
        }

        /* Profile Name */
        .side-navbar .sidenav-header-inner h2 {
            color: #008fda !important; /* BWD Blue */
            font-weight: 700 !important;
            font-size: 1.1rem !important;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
            font-family: 'Poppins', sans-serif;
        }

        /* Profile Role/Title - Modern Pill Style */
        .side-navbar .sidenav-header-inner span {
            color: #138D3C !important; /* BWD Green */
            font-size: 0.75rem !important;
            font-weight: 600;
            background: rgba(19, 141, 60, 0.08); /* Soft translucent green */
            padding: 6px 14px;
            border-radius: 50px;
            display: inline-block;
            line-height: 1.4;
        }

        /* Menu Heading (MENU) */
        .side-navbar .main-menu .sidenav-heading {
            color: #94a3b8 !important;
            font-weight: 600;
            letter-spacing: 1.5px;
            font-size: 0.75rem;
            margin-top: 25px;
            padding-left: 25px;
        }

        /* Modernized Badges (Replacing the ugly yellow ones) */
        .bwd-badge {
            background: rgba(0, 143, 218, 0.1) !important;
            color: #008fda !important;
            border-radius: 30px;
            font-weight: 600;
            font-size: 0.75rem;
            padding: 4px 10px;
            float: right;
            margin-top: 1px;
            box-shadow: none !important;
            transition: all 0.3s;
        }
        
        /* When hovering over a menu item, the badge turns green */
        nav.side-navbar ul li a:hover .bwd-badge,
        nav.side-navbar ul li.active > a .bwd-badge {
            background: rgba(19, 141, 60, 0.15) !important;
            color: #138D3C !important;
        }
    </style>

    <!-- Side Navbar -->
    <nav class="side-navbar">
      <div class="side-navbar-wrapper">
        
        <!-- Sidebar Header -->
        <div class="sidenav-header d-flex align-items-center justify-content-center">
          
          <!-- User Info-->
          <div class="sidenav-header-inner text-center">
            <img src="img/<?php echo $sf_row['logo']; ?>" alt="person" class="img-fluid rounded-circle">
            <h2 class="h5"><?php echo $name; ?></h2>
            
            <?php
            $DOHead_query = $conn->query("SELECT * FROM dept_offices WHERE officeHead_id='$user_personnel_id'");
            if($DOHead_query->rowCount()>0){
                $doh_row=$DOHead_query->fetch(); 
            ?>
                <span><?php echo $session_access; ?><br /><?php echo $doh_row['dept_office_name']; ?> Head</span>
            <?php }else{ ?>
                <span><?php echo $session_access; ?></span>
            <?php } ?>
          </div>
          
          <!-- Small Brand information, appears on minimized sidebar-->
          <div class="sidenav-header-logo">
              <a href="<?php echo $breadcrumb_home; ?>" class="brand-small text-center"> 
                  <strong>HR</strong><strong style="color: #008fda;">M</strong>
              </a>
          </div>
        </div>
        
        
        <?php if($session_access==='User') { ?>
        <div class="main-menu">
          <h5 class="sidenav-heading">MENU</h5>
          <ul id="side-main-menu" class="side-menu list-unstyled">
            <li><a href="list_personnel_individual_details.php?dept=<?php echo $user_dept; ?>&personnel_id=<?php echo $user_personnel_id; ?>"> <i class="icon-user"></i>Profile</a></li>
            <li><a href="home_user.php"><i class="icon-clock"></i>My Logsheet</a></li>
            <li><a href="list_news_users.php"> <i class="icon-bill"></i>News &amp; Announcements</a></li>
          </ul>
        </div>
        
        <?php } elseif($session_access==='Administrator') { ?>
            
        <!-- 1 Sidebar Navigation Menus-->
        <div class="main-menu">
          <h5 class="sidenav-heading">MENU</h5>
          <ul id="side-main-menu" class="side-menu list-unstyled">  
                          
            <li><a href="home.php"> <i class="icon-home"></i>Home</a></li>
            
            <li><a href="#company_profile_dd" aria-expanded="false" data-toggle="collapse" aria-controls="company_profile_dd"> <i class="fa fa-institution"></i>Business</a>
              <ul id="company_profile_dd" class="collapse list-unstyled ">
                <li><a href="school_preferences.php?sfp_stat=xEdit"> <i class="fa fa-info-circle"></i>Profile</a></li>
                <li><a href="institutional_calendar.php?mm=<?php echo date('m'); ?>&yyyy=<?php echo date('Y'); ?>"> <i class="fa fa-calendar"></i>Calendar</a></li>
                <li><a href="list_news.php"> <i class="fa fa-bell"></i>Announcement</a></li>
              </ul>
            </li>
            
            <li><a href="#personnels_dd" aria-expanded="false" data-toggle="collapse"> <i class="icon-user"></i>Personnel Mngt.</a>
              <ul id="personnels_dd" class="collapse list-unstyled ">
                
                <li><a href="list_personnel.php?dept=All"><i class="icon-user"></i> Personnels
                <div class="badge bwd-badge"> <?php echo $perCtr_all=$perCtr_query->rowCount(); ?></div></a></li>
                
                <li><a href="list_dept.php"> <i class="fa fa-tasks"></i>Dept. / Offices
                <div class="badge bwd-badge"><?php echo $do_TotalCtr; ?></div></a></li>
                
                <li><a href="list_designation.php"> <i class="fa fa-briefcase"></i>Designation 
                <div class="badge bwd-badge"><?php echo $desTotalCtr; ?></div></a></li>
                
                <li><a href="list_gass.php"> <i class="icon-website"></i>Salary Grade 
                <div class="badge bwd-badge"><?php echo $gassTotalCtr; ?></div></a></li>
                
                <li><a href="list_EStatus.php"> <i class="fa fa-drivers-license"></i>Appointment Status 
                <div class="badge bwd-badge"><?php echo $ES_TotalCtr; ?></div></a></li>
                
              </ul>
            </li>
            
            <li><a href="#leave_travel_dd" aria-expanded="false" data-toggle="collapse"> <i class="fa fa-plane"></i>Leave/Travel Mngt. </a>
              <ul id="leave_travel_dd" class="collapse list-unstyled ">
                <li><a href="list_travel_order.php?cw=list_travel"> <i class="fa fa-plane"></i>Travel Bulletin</a></li>
                <li><a href="list_leave.php?cw=list_leave"> <i class="fa fa-arrow-circle-left"></i>Leave Bulletin</a></li>
              </ul>
            </li>
            
            <li><a href="#time_mngt_dd" aria-expanded="false" data-toggle="collapse"> <i class="icon-clock"></i>Time Management </a>
              <ul id="time_mngt_dd" class="collapse list-unstyled ">
                <li><a href="list_shift.php"> <i class="icon-presentation"></i>Shifts 
                <div class="badge bwd-badge"><?php echo $shiftTotalCtr; ?></div></a></li>
                <li><a href="schedule_preferences.php?do_id=&shift_id=&shift=&type="> <i class="icon-clock"></i>Schedules</a></li>
                <li><a href="log_validation_viewer.php"> <i class="fa fa-search-plus"></i>Log Validations</a></li>
              </ul>
            </li>
            
            <li><a href="#others_dd" aria-expanded="false" data-toggle="collapse"> <i class="icon-screen"></i>Other Settings </a>
              <ul id="others_dd" class="collapse list-unstyled ">
                
                <li><a href="list_client_comp.php"> <i class="icon-screen"></i>Client CPU 
                <div class="badge bwd-badge"><?php echo $client_computerTotalCtr; ?></div></a></li>
                
                <li><a href="list_slides.php"> <i class="icon-picture"></i>Slides</a></li>
                
                <li><a href="csvFile_import.php"> <i class="fa fa-file-excel-o"></i>CSV Files</a></li>
                
                <li><a href="list_dbFiles_manager.php"> <i class="fa fa-database"></i>DB Files</a></li>
                
              </ul>
            </li>
            
            <li><a href="printReports.php"> <i class="icon-page"></i>Reports</a></li>
            
          </ul>
        </div>
        <!-- end 1 Sidebar Navigation Menus-->
        
        <?php } ?>
        
      </div>
    </nav>