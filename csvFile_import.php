<!DOCTYPE html>
<html>

  <?php
   include('session.php');
   include('header.php');
   include('csvFile_functions.php');
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
            <li class="breadcrumb-item active">Personnel Logs CSV File Manager</li>
          </ul>
        </div>
      </div>
      
      
      <section class="statistics mt-4 mb-5">
         <div class="container-fluid">
             
          <div class="row mb-4 px-3">
              <h3 class="text-uppercase" style="font-weight: 700; color: #444; letter-spacing: 1px;">
                  <i class="fa fa-file-excel-o mr-2 text-success"></i> Personnel Logs CSV File Manager
              </h3>
          </div>

          <div class="row d-flex">
       
            <div class="col-lg-6 mb-4">
              <div class="card shadow-sm border-0 h-100" style="border-top: 4px solid #28a745 !important;">
                <div class="card-header bg-white border-0 pt-4 pb-0">
                    <h2 class="h5 mb-0" style="font-weight: 700; color: #333;">Import .CSV File</h2>
                    <p class="text-muted small mt-1">Upload personnel logs from your local device to the database.</p>
                </div>
                
                <div class="card-body">
                <form class="form-horizontal" action="csvFile_functions.php" method="post" name="upload_excel" enctype="multipart/form-data">
                    <fieldset>
                        
                        <div class="form-group mb-4">
                            <label class="font-weight-bold" for="file">Select File</label>
                            <input type="file" name="file" id="file" class="form-control p-1" accept=".csv" required />
                        </div>
                        
                        <div class="form-group text-center mt-5">
                            <button type="submit" id="submit" name="Import" class="btn btn-success btn-lg shadow-sm w-100" style="font-weight: 600;">
                                <i class="fa fa-cloud-upload mr-2"></i> IMPORT CSV FILE
                            </button>
                        </div>
                        
                    </fieldset>
                </form>
                </div>
              </div>
            </div>
            
            
            <div class="col-lg-6 mb-4">
              <div class="card shadow-sm border-0 h-100" style="border-top: 4px solid #17a2b8 !important;">
                <div class="card-header bg-white border-0 pt-4 pb-0">
                    <h2 class="h5 mb-0" style="font-weight: 700; color: #333;">Export .CSV File</h2>
                    <p class="text-muted small mt-1">Download personnel logs from the database to your local device.</p>
                </div>
                
                <div class="card-body">
                <form class="form-horizontal" action="csvFile_functions.php" method="POST" name="upload_excel" enctype="multipart/form-data">
                  
                  <div class="row mb-4">
                      <div class="col-md-6 form-group mb-3">
                          <label class="font-weight-bold text-muted small text-uppercase">From Date</label>
                          <input type="date" name="logDateFrom" class="form-control" required />
                      </div>
                      
                      <div class="col-md-6 form-group mb-3">
                          <label class="font-weight-bold text-muted small text-uppercase">To Date</label>
                          <input type="date" name="logDateTo" class="form-control" required /> 
                      </div>
                  </div>
                  
                  <div class="form-group text-center mt-4">
                      <button type="submit" name="Export" class="btn btn-info btn-lg shadow-sm w-100" style="font-weight: 600;">
                          <i class="fa fa-cloud-download mr-2"></i> EXPORT CSV FILE
                      </button>
                  </div>
                    
                </form>
                </div>
              </div>
            </div>
            
          </div>
        </div>
      </section>
      
      <?php include('footer.php'); ?>
      
    </div>
    
    <?php include('scripts_files.php'); ?>
    
  </body>
</html>