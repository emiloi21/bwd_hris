<header class="header">
    <nav class="navbar">
        <div class="container-fluid">
            
            <div class="navbar-holder d-flex align-items-center justify-content-between">
                
                <div class="navbar-menu-container mr-3">
                    <a id="toggle-btn" href="#" class="menu-btn d-flex align-items-center justify-content-center"style="margin-left: -40px;"  >
                        <i class="icon-bars"></i>
                    </a>
                </div>

                <div class="navbar-header d-flex align-items-center flex-grow-1">
                    <a href="home.php" class="navbar-brand d-flex align-items-center mb-0">
                        <div class="brand-text d-none d-md-inline-block m-0 p-0" style="line-height: 1; margin-left: 10px; margin-top: 10px;">
                            <strong class="text-primary">HUMAN RESOURCE MANAGEMENT SYSTEM</strong>
                        </div>
                    </a>
                </div>
                
                <ul class="nav-menu list-unstyled d-flex flex-row align-items-center mb-0">
                    
                    <li id="bwd-clock-container" class="nav-item d-none d-md-flex align-items-center mr-3">
                        <div id="bwd-live-clock" class="bwd-live-clock">
                            </div>
                    </li>
               
                    <?php if($session_access==='Administrator'){ 
                        $mm = date("m"); //month
                        $dd = date("d"); //day
                        $studBday_query = $conn->query("select * from personnels WHERE bdMM='$mm' AND bdDD='$dd'");
                    ?>
                        <li title="Search student..." class="nav-item dropdown">
                            <a id="notifications" rel="nofollow" data-target="#" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="nav-link">
                                <i class="fa fa-search"></i>
                            </a>
                            <ul aria-labelledby="notifications" class="dropdown-menu">
                                <li>
                                    <form method="POST" action="list_personnel.php?dept=All" class="px-3 py-2 m-0">
                                        <input name="searchStudent" list="search_list" placeholder="Search for personnel..." class="form-control" required="true" style="width: 300px;" />
                                        <datalist id="search_list">
                                            <?php
                                            $fnameList_query = $conn->query("SELECT DISTINCT personnel_id_code, lname, fname, mname FROM personnels");
                                            while($fnlq_row = $fnameList_query->fetch()){ ?>
                                                <option value="<?php echo $fnlq_row['personnel_id_code']; ?>">
                                                    <?php echo $fnlq_row['personnel_id_code']; ?> | <small><?php echo $fnlq_row['lname'].', '.$fnlq_row['fname'].' '.$fnlq_row['mname']; ?></small>
                                                </option>
                                            <?php } ?>
                                        </datalist>
                                        <button name="search" class="btn btn-primary" style="display: none;"><i class="fa fa-search"></i></button>
                                    </form> 
                                </li>
                            </ul>
                        </li>
                    <?php } ?>  
                    
                    <li class="nav-item dropdown ml-2"> 
                        <a id="messages" rel="nofollow" data-target="#" href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="nav-link">
                            <i class="fa fa-user-circle" style="font-size: 1.2rem;"></i>
                            <span class="badge badge-info"><i class="fa fa-cog fa-sm"></i></span>
                        </a>
                        <ul aria-labelledby="notifications" class="dropdown-menu dropdown-menu-right">
                            <li>
                                <a rel="nofollow" href="user_profile.php?cw=UserProfile&dept=<?php echo $user_dept; ?>&personnel_id=<?php echo $user_personnel_id; ?>" class="dropdown-item d-flex align-items-center"> 
                                    <div class="msg-profile mr-3"> 
                                        <img src="img/<?php echo $sf_row['logo']; ?>" alt="..." class="img-fluid rounded-circle" style="width: 45px; height: 45px; object-fit: contain;">
                                    </div>
                                    <div class="msg-body">
                                        <h3 class="h6 mb-0"><?php echo $user_row['fname']; ?>'s Profile</h3>
                                        <span class="d-block text-muted" style="font-size: 0.8rem;"><?php echo $name; ?></span>
                                        <small class="text-primary font-weight-bold"><?php echo $session_access; ?></small>
                                    </div>
                                </a>
                            </li>
                            <div class="dropdown-divider"></div>
                            <li>
                                <a rel="nofollow" href="logout.php" class="dropdown-item all-notifications text-center text-danger"> 
                                    <strong><i class="fa fa-sign-out"></i> Logout</strong>
                                </a>
                            </li>
                        </ul>
                    </li>
                     
                </ul>
            </div>
        </div>
    </nav>
</header>