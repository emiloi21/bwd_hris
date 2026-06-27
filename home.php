<!DOCTYPE html>
<html>

  <?php
   include('session.php');
   include('header.php'); 
   
    $day = date("l"); //Mon-Sun
    
    if(isset($_POST['filterDate'])){
        $filterDate = $_POST['reportDate'];
    } else {
        $filterDate = date('m/d/Y');
    } 
  ?>
    
  <body>
  
  <?php include('menu_sidebar.php'); ?>

    <div class="page">
    
    <?php include('navbar_header.php');
    
    if($session_access === 'User') { ?>
        <script>
            window.location = 'list_personnel_individual_details.php?dept=<?php echo $user_dept; ?>&personnel_id=<?php echo $user_personnel_id; ?>';
        </script>
    <?php } elseif($session_access === 'Administrator') {
        include('quick_count.php');
    } ?>
    
    <?php if($session_access === 'Administrator') {  ?>
    
    <?php 
    // Display notification if monthly leave credits were just processed
    if (isset($_SESSION['monthly_credits_processed'])) {
        $result = $_SESSION['monthly_credits_processed'];
        if ($result['success'] && $result['count'] > 0) {
            echo '<div class="container-fluid mt-3">';
            echo '<div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 10px; box-shadow: 0 4px 15px rgba(19, 141, 60, 0.1); border: none;">';
            echo '<strong><i class="fa fa-check-circle" style="color: #138D3C;"></i> Monthly Leave Credits Processed!</strong><br>';
            echo htmlspecialchars($result['message']);
            echo '<button type="button" class="close" data-dismiss="alert" aria-label="Close">';
            echo '<span aria-hidden="true">&times;</span>';
            echo '</button>';
            echo '</div>';
            echo '</div>';
        }
        unset($_SESSION['monthly_credits_processed']); // Clear the notification
    }
    ?>

        <style>
            /* System Summary Cards (Top Row) */
            .bwd-summary-card {
                background: #ffffff;
                border-radius: 14px;
                padding: 24px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
                border: 1px solid #eef2f5;
                height: 100%;
                position: relative;
                overflow: hidden;
                transition: transform 0.3s ease;
            }
            .bwd-summary-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(0, 143, 218, 0.06);
            }
            .bwd-summary-icon {
                position: absolute;
                right: -15px;
                top: -10px;
                font-size: 6rem;
                opacity: 0.04;
                color: #008fda;
            }
            .bwd-summary-title {
                font-size: 0.8rem;
                font-weight: 700;
                text-transform: uppercase;
                color: #64748b;
                letter-spacing: 1px;
                margin-bottom: 10px;
            }
            .bwd-summary-value {
                font-size: 2.5rem;
                font-weight: 700;
                color: #1e293b;
                line-height: 1;
                margin-bottom: 15px;
            }
            .bwd-summary-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }
            .bwd-summary-list li {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 0.85rem;
                padding: 8px 0;
                border-bottom: 1px dashed #f1f5f9;
                color: #475569;
            }
            .bwd-summary-list li:last-child { border-bottom: none; }
            .bwd-summary-list li span.badge {
                background: #f8fafc;
                color: #008fda;
                font-weight: 600;
                padding: 4px 8px;
                border-radius: 6px;
                font-size: 0.75rem;
            }

            /* Department Cards (Bottom Row) */
            .bwd-dept-card {
                background: #ffffff;
                border-radius: 14px;
                padding: 24px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
                border: 1px solid #eef2f5;
                transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
                position: relative;
                overflow: hidden;
                display: flex;
                flex-direction: column;
                height: 100%;
            }
            .bwd-dept-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 30px rgba(0, 143, 218, 0.08);
                border-color: rgba(0, 143, 218, 0.2);
            }
            .bwd-dept-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 20px;
            }
            .bwd-dept-title {
                font-size: 1.15rem;
                font-weight: 700;
                color: #008fda;
                text-decoration: none !important;
                line-height: 1.3;
            }
            .bwd-dept-title:hover { color: #006fa8; }
            .bwd-head-box {
                background: #f8fafc;
                border-radius: 10px;
                padding: 12px 16px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                border: 1px solid #f1f5f9;
            }
            .bwd-head-icon {
                background: rgba(19, 141, 60, 0.1);
                color: #138D3C;
                width: 36px;
                height: 36px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 12px;
                font-size: 1.1rem;
                flex-shrink: 0;
            }
            .bwd-head-info { display: flex; flex-direction: column; }
            .bwd-head-label {
                font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px;
                color: #64748b; font-weight: 600; margin-bottom: 2px;
            }
            .bwd-head-name { font-size: 0.9rem; font-weight: 600; color: #1e293b; }
            .bwd-stats-grid {
                display: flex; justify-content: space-between; margin-bottom: 20px; margin-top: auto; 
            }
            .bwd-stat-item { text-align: center; }
            .bwd-stat-value { font-size: 1.6rem; font-weight: 700; line-height: 1; margin-bottom: 4px; }
            .bwd-stat-value.total { color: #1e293b; }
            .bwd-stat-value.male { color: #008fda; }
            .bwd-stat-value.female { color: #138D3C; }
            .bwd-stat-label { font-size: 0.75rem; color: #64748b; font-weight: 500; display: flex; align-items: center; justify-content: center; gap: 4px; }
            
            /* Gender Ratio Bar */
            .bwd-ratio-wrapper {
                background: #f1f5f9; border-radius: 20px; height: 8px; width: 100%; display: flex; overflow: hidden;
            }
            .bwd-ratio-male { background: #008fda; height: 100%; transition: width 1s ease-in-out; }
            .bwd-ratio-female { background: #138D3C; height: 100%; transition: width 1s ease-in-out; }
            
            /* Section Headers */
            .bwd-section-title {
                font-size: 1.2rem; font-weight: 700; color: #1e293b; margin: 30px 0 20px 0;
                padding-left: 12px; border-left: 4px solid #138D3C;
            }
        </style>
    
        <section class="statistics mt-4">
         <div class="container-fluid">
         
          <h4 class="bwd-section-title mt-0">System Overview</h4>
          <div class="row">
              
              <?php
              // --- QUICK COUNT QUERIES FOR SUMMARY CARDS ---
              // Total Active Employees
              $sys_emp_tot = $conn->query("SELECT COUNT(*) FROM personnels WHERE separation_date IS NULL OR separation_date = ''")->fetchColumn();
              $sys_emp_m = $conn->query("SELECT COUNT(*) FROM personnels WHERE sex='Male' AND (separation_date IS NULL OR separation_date = '')")->fetchColumn();
              $sys_emp_f = $conn->query("SELECT COUNT(*) FROM personnels WHERE sex='Female' AND (separation_date IS NULL OR separation_date = '')")->fetchColumn();
              
              // Active Job Status
              $active_status_query = $conn->query("SELECT e.emp_stat_name, COUNT(p.personnel_id) as total FROM emp_status e LEFT JOIN personnels p ON e.empStat_id = p.empStat_id AND (p.separation_date IS NULL OR p.separation_date = '') WHERE e.status = 'Active' GROUP BY e.empStat_id ORDER BY e.emp_stat_name ASC");
              
              // Separated Job Status
              $separated_status_query = $conn->query("SELECT e.emp_stat_name, COUNT(p.personnel_id) as total FROM emp_status e LEFT JOIN personnels p ON e.empStat_id = p.empStat_id AND p.separation_date IS NOT NULL AND p.separation_date != '' WHERE e.status = 'Separated' GROUP BY e.empStat_id ORDER BY e.emp_stat_name ASC");
              
              // Configs
              $sys_shifts = $conn->query("SELECT COUNT(*) FROM shifts")->fetchColumn();
              $sys_clients = $conn->query("SELECT COUNT(*) FROM client_computer")->fetchColumn();
              ?>

              <div class="col-xl-3 col-lg-6 mb-4">
                  <div class="bwd-summary-card">
                      <i class="fa fa-users bwd-summary-icon"></i>
                      <div class="bwd-summary-title">Registered Employees</div>
                      <div class="bwd-summary-value text-primary"><?php echo $sys_emp_tot; ?></div>
                      <ul class="bwd-summary-list">
                          <li><span class="text-muted"><i class="fa fa-male mr-2 text-info"></i>Male</span> <span class="badge"><?php echo $sys_emp_m; ?></span></li>
                          <li><span class="text-muted"><i class="fa fa-female mr-2 text-success"></i>Female</span> <span class="badge"><?php echo $sys_emp_f; ?></span></li>
                      </ul>
                  </div>
              </div>

              <div class="col-xl-3 col-lg-6 mb-4">
                  <div class="bwd-summary-card">
                      <i class="fa fa-id-badge bwd-summary-icon" style="color: #138D3C;"></i>
                      <div class="bwd-summary-title">Active Job Status</div>
                      <ul class="bwd-summary-list mt-3">
                          <?php while($stat = $active_status_query->fetch()) { ?>
                              <li><span><i class="fa fa-circle mr-2" style="font-size: 8px; color:#138D3C;"></i><?php echo $stat['emp_stat_name']; ?></span> <span class="badge"><?php echo $stat['total']; ?></span></li>
                          <?php } ?>
                      </ul>
                  </div>
              </div>

              <div class="col-xl-3 col-lg-6 mb-4">
                  <div class="bwd-summary-card">
                      <i class="fa fa-user-times bwd-summary-icon" style="color: #ef4444;"></i>
                      <div class="bwd-summary-title">Separated Records</div>
                      <ul class="bwd-summary-list mt-3">
                          <?php while($sep = $separated_status_query->fetch()) { ?>
                              <li><span><i class="fa fa-circle mr-2" style="font-size: 8px; color:#ef4444;"></i><?php echo $sep['emp_stat_name']; ?></span> <span class="badge" style="background:#fef2f2; color:#ef4444;"><?php echo $sep['total']; ?></span></li>
                          <?php } ?>
                      </ul>
                  </div>
              </div>

              <div class="col-xl-3 col-lg-6 mb-4">
                  <div class="bwd-summary-card">
                      <i class="fa fa-cogs bwd-summary-icon" style="color: #8b5cf6;"></i>
                      <div class="bwd-summary-title">System Configurations</div>
                      <ul class="bwd-summary-list mt-3">
                          <li><span><i class="fa fa-clock-o mr-2 text-warning"></i>Work Shifts Configured</span> <span class="badge"><?php echo $sys_shifts; ?></span></li>
                          <li><span><i class="fa fa-desktop mr-2 text-secondary"></i>Registered Client CPUs</span> <span class="badge"><?php echo $sys_clients; ?></span></li>
                      </ul>
                  </div>
              </div>

          </div>
          
          <h4 class="bwd-section-title">Department Breakdown</h4>
          <div class="row">
             
            <?php
            $dept_off_query = $conn->query("SELECT * FROM dept_offices ORDER BY dept_office_name ASC");
            while ($do_row = $dept_off_query->fetch()) 
            { 
            
            // Fetch Statistics per department
            $per_ctr_stmt = $conn->prepare("SELECT COUNT(*) FROM personnels WHERE do_id = :do_id AND (separation_date IS NULL OR separation_date = '')");
            $per_ctr_stmt->execute([':do_id' => $do_row['do_id']]);
            $per_ctr_count = (int)$per_ctr_stmt->fetchColumn();

            $male_per_ctr_stmt = $conn->prepare("SELECT COUNT(*) FROM personnels WHERE do_id = :do_id AND sex = 'Male' AND (separation_date IS NULL OR separation_date = '')");
            $male_per_ctr_stmt->execute([':do_id' => $do_row['do_id']]);
            $male_per_ctr_count = (int)$male_per_ctr_stmt->fetchColumn();

            $female_per_ctr_stmt = $conn->prepare("SELECT COUNT(*) FROM personnels WHERE do_id = :do_id AND sex = 'Female' AND (separation_date IS NULL OR separation_date = '')");
            $female_per_ctr_stmt->execute([':do_id' => $do_row['do_id']]);
            $female_per_ctr_count = (int)$female_per_ctr_stmt->fetchColumn();
            
            // Calculate Percentages for Data Storytelling Bar
            $male_pct = ($per_ctr_count > 0) ? round(($male_per_ctr_count / $per_ctr_count) * 100) : 0;
            $female_pct = ($per_ctr_count > 0) ? round(($female_per_ctr_count / $per_ctr_count) * 100) : 0;
            ?>
            
            <div class="col-lg-4 col-md-6 mb-4">
              <div class="bwd-dept-card">
                
                <div class="bwd-dept-header">
                    <a href="list_personnel.php?dept=<?php echo $do_row['do_id']; ?>" class="bwd-dept-title" title="Proceed to <?php echo htmlspecialchars($do_row['dept_office_name']); ?> personnel list">
                        <?php echo htmlspecialchars($do_row['dept_office_name']); ?>
                    </a>
                    
                    <div class="dropdown">
                        <button title="Options" data-toggle="dropdown" type="button" class="btn btn-sm btn-light" style="background: transparent; border: none; color: #94a3b8;">
                            <i class="fa fa-ellipsis-v"></i>
                        </button>
                        <div class="dropdown-menu dropdown-menu-right shadow-sm border-0">
                            <a title="Print list of <?php echo htmlspecialchars($do_row['dept_office_name']); ?> personnels" href="printPersonnelPerDept.php?do_id=<?php echo $do_row['do_id']; ?>" target="_blank" class="dropdown-item">
                                <i class="fa fa-print text-muted mr-2"></i> Print Personnel List
                            </a>
                            <a href="#" data-toggle="modal" data-target="#setDOHead<?php echo $do_row['do_id']; ?>" class="dropdown-item">
                                <i class="fa fa-user-edit text-muted mr-2"></i> Assign Dept Head
                            </a>
                        </div>
                    </div>
                </div>

                <div class="bwd-head-box">
                    <div class="bwd-head-icon">
                        <i class="fa fa-user-tie"></i>
                    </div>
                    <div class="bwd-head-info">
                        <span class="bwd-head-label">Department Head</span>
                        <span class="bwd-head-name">
                        <?php
                            $officeHead_stmt = $conn->prepare("SELECT * FROM personnels WHERE personnel_id = :personnel_id");
                            $officeHead_stmt->execute([':personnel_id' => $do_row['officeHead_id']]);
                            $oh_row = $officeHead_stmt->fetch();
                            
                            if (!empty($oh_row)){
                                if($oh_row['suffix'] == "-") {
                                    echo htmlspecialchars($oh_row['fname']." ".substr($oh_row['mname'], 0,1).". ".$oh_row['lname']);
                                } else {
                                    echo htmlspecialchars($oh_row['fname']." ".substr($oh_row['mname'], 0,1).". ".$oh_row['lname']." ".$oh_row['suffix']);
                                } 
                            } else {
                                echo "<span style='color: #ef4444; font-size: 0.85rem;'>No Assigned Personnel</span>";
                            }
                        ?>
                        </span>
                    </div>
                </div>

                <div class="bwd-stats-grid">
                    <div class="bwd-stat-item">
                        <div class="bwd-stat-value male"><?php echo $male_per_ctr_count; ?></div>
                        <div class="bwd-stat-label"><i class="fa fa-male" style="color:#008fda;"></i> Male</div>
                    </div>
                    <div class="bwd-stat-item border-left border-right px-4" style="border-color: #f1f5f9 !important;">
                        <div class="bwd-stat-value total"><?php echo $per_ctr_count; ?></div>
                        <div class="bwd-stat-label"><i class="fa fa-users text-muted"></i> Total</div>
                    </div>
                    <div class="bwd-stat-item">
                        <div class="bwd-stat-value female"><?php echo $female_per_ctr_count; ?></div>
                        <div class="bwd-stat-label"><i class="fa fa-female" style="color:#138D3C;"></i> Female</div>
                    </div>
                </div>

                <div class="bwd-ratio-wrapper" title="Gender Ratio: <?php echo $male_pct; ?>% Male, <?php echo $female_pct; ?>% Female">
                    <div class="bwd-ratio-male" style="width: <?php echo $male_pct; ?>%;"></div>
                    <div class="bwd-ratio-female" style="width: <?php echo $female_pct; ?>%;"></div>
                </div>
                
              </div>
            </div>
            
            <?php include('setDOHead_modal.php'); ?>
            
            <?php } ?>
            
          </div>
        </div>
      </section>
      
      <?php } ?>
      
      <?php include('footer.php'); ?>
      
    </div>
    
    <?php include('scripts_files.php'); ?>
    
  </body>
</html>