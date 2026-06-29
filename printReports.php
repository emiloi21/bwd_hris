<!DOCTYPE html>
<html>

  <?php
   include('session.php');
   include('header.php');
   ?>
  
  <body>
  
  <?php include('menu_sidebar.php'); ?>
  
    <div class="page">

    <?php include('navbar_header.php'); ?>
    
    <div class="breadcrumb-holder">
        <div class="container-fluid">
          <ul class="breadcrumb">
            <li style="color: blue"><strong style="margin-right: 4px;"><?php echo $schoolName; ?> | </strong></li>
            <li class="breadcrumb-item"><a href="home.php">Home</a></li>
            <li class="breadcrumb-item active">Print Reports</li>
          </ul>
        </div>
      </div>
      
      <section class="mt-30px mb-30px">
        <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 col-md-12">
              
              <div id="new-updates" class="card updates recent-updated">
                <div id="updates-header" class="card-header d-flex justify-content-between align-items-center">
                  <h2 class="h5 display">
                  <a data-toggle="collapse" data-parent="#new-updates" href="#updates-boxKinder" aria-expanded="true" aria-controls="updates-boxKinder"><strong style="font-weight: bold !important;">REPORTS</strong></a>
                  </h2><a data-toggle="collapse" data-parent="#new-updates" href="#updates-boxKinder" aria-expanded="true" aria-controls="updates-boxKinder"><i class="fa fa-angle-down"></i></a>
                </div>
                
                <div id="updates-boxKinder" role="tabpanel" class="collapse show">
                    
                    <div class="d-flex flex-wrap align-items-center p-3" style="gap: 15px; background-color: #e9f3f9; border-bottom: 1px solid #dee2e6;">
                        
                        <a href="printReports.php" class="btn btn-success shadow-sm">ATTENDANCE REPORTS</a>
                        
                        <div class="dropdown">
                          <button class="btn btn-success dropdown-toggle shadow-sm" type="button" id="personnelDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            PERSONNEL REPORTS
                          </button>
                          <div class="dropdown-menu shadow" aria-labelledby="personnelDropdown">
                            <a class="dropdown-item py-2" href="printReports_byAge.php?crw=AGE">Age with Date of Birth</a>
                            <a class="dropdown-item py-2" href="printReports_byEduc.php?crw=EDUCATION">Educational Attainment</a>
                            <a class="dropdown-item py-2" href="printReports_bySeminar.php?crw=SEMINAR">Seminars Attended</a>
                            <a class="dropdown-item py-2" href="printReports_byService.php?crw=SERVICE">Date Hired with No. of Years</a>
                          </div>
                        </div>
                        
                        <div class="dropdown">
                          <button class="btn btn-success dropdown-toggle shadow-sm" type="button" id="companyDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            COMPANY REPORTS
                          </button>
                          <div class="dropdown-menu shadow" aria-labelledby="companyDropdown">
                            <a class="dropdown-item py-2" href="#">Calendar</a>
                          </div>
                        </div>

                    </div>

                    <div class="px-3 pt-4 pb-2">
                        <strong style="font-size: 18px; color: #444;">ATTENDANCE REPORTS</strong>
                    </div>
                    <form action="checkPrintDetails.php" method="POST">
                
                <div style="margin: 10px 10px 10px 12px;" class="form-group row">
                <div class="col-lg-12">
                                        <div class="row">
                                          <div class="col-md-4 mb-3">
                                             <label class="font-weight-bold">Date ( MM/YYYY )</label>
                                            <input type="month" name="dateFrom" value="<?php echo date('Y-m'); ?>" class="form-control" />
                                          </div>
                                          
                                          <div class="col-md-4 mb-3">
                                             <label class="font-weight-bold">Type of Report</label>
                                            <select name="doc_type" class="form-control">
                                            <optgroup label="Log Reports"></optgroup>
                                            <option>CS Form 48 (1-15)</option>
                                            <option>CS Form 48 (16-31)</option>
                                            <option>CS Form 48</option>
                                            <option>Detailed DTR</option>
                                            <option>Log Validation History</option>
                                            <optgroup label="Leave, Travel/Seminar Reports"></optgroup>
                                            <option>Leave Application Forms</option>
                                            <option>Leave Summary</option>
                                            </select>
                                          </div>
                                          
                                          <div class="col-md-4 mb-3">
                                            <label class="font-weight-bold">Department / Office</label>
                                            <select name="do_id" class="form-control">
                                            <option value="print_all">All</option>
                                            <?php
                                            $emp_stat_query = $conn->query("select * from dept_offices ORDER BY dept_office_name ASC");
                                            while($es_row=$emp_stat_query->fetch()){
                                            ?>
                                            <option value="<?php echo $es_row['do_id']; ?>"><?php echo $es_row['dept_office_name']; ?></option>
                                            <?php } ?>
                                            </select>
                                            
                                          </div>
                                        </div>
                </div>
                </div>
                
                <div class="modal-footer border-top-0 pt-0">
                <button name="print_monthly_dtr" type="submit" class="btn btn-primary px-4">Print Preview</button>
                </div>
                </form>
                
                 
                </div>
              </div>
              
            </div>
            
          </div>
        </div>
        
        <?php include('add_client_comp_modal.php'); ?>
                  
      </section>
      
      <?php include('footer.php'); ?>
      
    </div>
    
    <?php include('scripts_files.php'); ?>

  </body>
</html>