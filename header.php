<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title><?php echo isset($sf_row['institution_name']) ? $sf_row['institution_name'] : 'Binalbagan Water District'; ?></title>
    <meta name="description" content="HRIS System">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="all,follow">
    
    <!-- Data Tables -->
    <link rel="stylesheet" type="text/css" href="DataTables/datatables.min.css"/>
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <!-- Google Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    
    <!-- Bootstrap CSS-->
    <link rel="stylesheet" href="vendor/bootstrap/css/bootstrap.min.css" />
    <!-- Font Awesome CSS-->
    <link rel="stylesheet" href="vendor/font-awesome/css/font-awesome.min.css" />
    <!-- Theme Stylesheets -->
    <link rel="stylesheet" href="css/fontastic.css" />
    <link rel="stylesheet" href="css/grasp_mobile_progress_circle-1.0.0.min.css" />
    <link rel="stylesheet" href="vendor/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.css" />
    
    <!-- DEFAULT THEME (We will override this below) -->
    <link rel="stylesheet" href="css/style.default.css" id="theme-stylesheet" />
    <link rel="stylesheet" href="css/custom.css" />
    
    <!-- Favicon-->
    <link rel="shortcut icon" href="img/<?php echo isset($sf_row['logo']) ? $sf_row['logo'] : ''; ?>" />
    
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- =========================================
         BWD CUSTOM THEME OVERRIDES 
         ========================================= -->
    <style>
    :root {
        --bwd-blue: #008fda;       
        --bwd-blue-dark: #006fa8;  
        --bwd-green: #138D3C;      
        --bwd-green-dark: #0e6b2c; 
        --bg-white: #ffffff;
        --bg-page: #f4f7f6;
        --border-soft: #e2e8f0;
        --text-main: #2c3e50;
        --text-muted: #64748b;
    }

    body, p, span, a, div, h1, h2, h3, h4, h5, h6 { font-family: 'Poppins', sans-serif; }

    /* Custom Scrollbar */
    ::-webkit-scrollbar { width: 8px; height: 8px; }
    ::-webkit-scrollbar-track { background: #f1f1f1; }
    ::-webkit-scrollbar-thumb { background: var(--bwd-blue); border-radius: 4px; }
    ::-webkit-scrollbar-thumb:hover { background: var(--bwd-blue-dark); }


    /* =========================================
       1. TOP NAVBAR FIXES (HEADER)
       ========================================= */
    header.header, nav.navbar {
        background: var(--bg-white) !important;
        border-bottom: 3px solid var(--bwd-blue) !important; 
    }

    /* Force the main header text (HUMAN RESOURCE...) to be BWD Blue */
    .navbar-header h1, 
    .navbar-header .brand-text,
    .navbar-header .brand-text *,
    .brand-text span {
        color: var(--bwd-blue) !important;
        font-weight: 700 !important;
    }

    /* Hide the old hardcoded date next to the title (if it exists) */
    .navbar-header .brand-text small {
        display: none !important;
    }

    /* --- THE NEW CLOCK UI (Black, Smaller, Top Right) --- */
    .bwd-live-clock {
        color: #000000 !important; /* Pure Black text */
        font-size: 0.8rem !important; /* Smaller size */
        font-weight: 500;
        margin-right: 15px; /* Creates space between the clock and the search icon */
        display: inline-flex;
        align-items: center;
        letter-spacing: 0.5px;
    }
    .bwd-live-clock i {
        color: #000000 !important;
        margin-right: 6px;
        font-size: 0.9rem;
    }

    /* Fix the dark black square on the Hamburger Menu Button */
    header.header .menu-btn {
        background: transparent !important;
        color: var(--bwd-blue) !important;
        border-radius: 6px !important;
        transition: background 0.3s ease;
    }
    header.header .menu-btn:hover { background: #e0f2fe !important; }

    /* Fix Top Right Icons */
    .navbar .nav-link, .navbar i { color: var(--text-main) !important; }
    .navbar .nav-link:hover, .navbar i:hover { color: var(--bwd-blue) !important; }


    /* =========================================
       2. LOGO BADGE FIX
       ========================================= */
    .navbar-brand img, header.header img {
        background-color: transparent !important;
        width: 45px !important; 
        height: auto !important;
        margin-right: 10px;
        transition: transform 0.3s ease;
    }
    .navbar-brand:hover img { transform: scale(1.08); }


    /* =========================================
       3. SIDEBAR FIXES (REMOVING ALL BLACK/GREEN)
       ========================================= */
    nav.side-navbar, nav.side-navbar .sidebar-header, nav.side-navbar ul li, nav.side-navbar ul li a, nav.side-navbar ul li ul.collapse, nav.side-navbar ul li ul.collapse li, nav.side-navbar ul li ul.collapse li a {
        background: var(--bg-white) !important; background-color: var(--bg-white) !important; color: var(--text-main) !important; border-color: var(--border-soft) !important;
    }
    nav.side-navbar .sidebar-header h1, nav.side-navbar .sidebar-header h1.h5, nav.side-navbar .sidebar-header p, nav.side-navbar span.heading {
        color: var(--text-main) !important;
    }
    nav.side-navbar ul li.active > a, nav.side-navbar ul li a:hover, nav.side-navbar ul li ul.collapse li.active > a, nav.side-navbar ul li ul.collapse li a:hover {
        background-color: #f0fdf4 !important; color: var(--bwd-green) !important; border-left: 4px solid var(--bwd-green) !important; font-weight: 600 !important;
    }
    nav.side-navbar ul li ul.collapse li a { border-left: 4px solid transparent !important; padding-left: 40px !important; }
    nav.side-navbar ul li a i { color: var(--bwd-blue) !important; }
    nav.side-navbar ul li.active > a i, nav.side-navbar ul li a:hover i { color: var(--bwd-green) !important; }


    /* =========================================
       4. FOOTER FIX (Hiding the date on the right side)
       ========================================= */
    footer.main-footer {
        background: var(--bg-white) !important;
        border-top: 1px solid var(--border-soft) !important;
    }
    footer.main-footer p { color: var(--text-muted) !important; }
    footer.main-footer a { color: var(--bwd-blue) !important; font-weight: 600; }
    
    /* Hides the right side of the footer where the date/version usually is */
    footer.main-footer .col-sm-6.text-right {
        display: none !important;
    }


    /* =========================================
       5. CONTENT AREA & TABLES
       ========================================= */
    .page, .content-inner { background-color: var(--bg-page) !important; }
    div.dataTables_wrapper { margin-bottom: 3em; }
    table.display, table, table.dataTable { border-collapse: separate !important; border-spacing: 0; width: 100%; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.03); border: 1px solid var(--border-soft); }
    table.display td, table td { border-bottom: 1px solid var(--border-soft); padding: 14px 18px; color: var(--text-main); font-size: 0.9rem; }
    table.display th, table th { padding: 16px 18px; text-align: left; background-color: var(--bwd-blue); color: white; font-weight: 600; font-size: 0.9rem; border: none; }
    table.display tr:last-child td, table tr:last-child td { border-bottom: none; }
    table.display tr:nth-child(even), table tr:nth-child(even) { background-color: #f8fafc; }
    table.display tr:hover td, table tr:hover td { background-color: #e0f2fe !important; }

    .tab { overflow: visible; border: none; border-bottom: 2px solid var(--border-soft); background-color: transparent; display: flex; gap: 5px; }
    .tab a { background-color: transparent; color: var(--text-muted) !important; border: none; outline: none; cursor: pointer; padding: 12px 24px; font-size: 14px; font-weight: 600; text-decoration: none; position: relative; }
    .tab a::after { content: ''; position: absolute; bottom: -2px; left: 50%; transform: translateX(-50%); width: 0; height: 3px; background-color: var(--bwd-green); transition: width 0.3s ease; border-radius: 3px 3px 0 0; }
    .tab a:hover { color: var(--bwd-green) !important; }
    .tab a.active { color: var(--bwd-green) !important; background-color: transparent; }
    .tab a.active::after { width: 100%; }
    .tabcontent { display: none; padding: 25px; background-color: #fff; border-radius: 0 0 10px 10px; box-shadow: 0 8px 20px rgba(0,0,0,0.02); }

    .dropbtn { background-color: var(--bwd-green); color: white; font-size: 14px; font-weight: 500; border: none; margin-top: 5px; height: 40px; padding: 8px 20px; border-radius: 6px; cursor: pointer; transition: background-color 0.3s ease; }
    .dropbtn:hover { background-color: var(--bwd-green-dark); }
    .dropdown { position: relative; display: inline-block; }
    .dropdown-content { display: none; position: absolute; background-color: #ffffff; min-width: 200px; box-shadow: 0px 10px 25px rgba(0,0,0,0.1); z-index: 1000; border-radius: 8px; margin-top: 5px; border: 1px solid var(--border-soft); padding: 8px 0; }
    .dropdown-content a { color: var(--text-main); padding: 10px 20px; text-decoration: none; display: block; font-size: 13px; transition: all 0.2s; }
    .dropdown-content a:hover { background-color: #f0fdf4; color: var(--bwd-green); padding-left: 25px; }
    .dropdown:hover .dropdown-content { display: block; }
    </style>

    <!-- =========================================
         PHILIPPINE STANDARD TIME (AUTO-INJECTION)
         ========================================= -->
    <script>
    document.addEventListener("DOMContentLoaded", function() {
        
        // 1. This finds the right side of the navbar and injects the clock automatically 
        // before the search/profile icons so you don't have to edit other files.
        const rightNavMenu = document.querySelector('.nav-menu');
        if(rightNavMenu && !document.getElementById('bwd-clock-container')) {
            const clockLi = document.createElement('li');
            clockLi.className = 'nav-item d-none d-md-flex align-items-center';
            clockLi.id = 'bwd-clock-container';
            clockLi.innerHTML = '<div id="bwd-live-clock" class="bwd-live-clock"></div>';
            
            // Insert it before the very first icon in the right menu (usually search)
            rightNavMenu.insertBefore(clockLi, rightNavMenu.firstChild);
        }

        // 2. This runs the clock calculations
        function updatePSTClock() {
            const now = new Date();
            
            // Force Asia/Manila Timezone for the Date
            const dateStr = now.toLocaleDateString('en-US', { 
                timeZone: 'Asia/Manila', 
                weekday: 'short', 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric' 
            });
            
            // Force Asia/Manila Timezone for the Time (hh:mm:ss AM/PM)
            const timeStr = now.toLocaleTimeString('en-US', { 
                timeZone: 'Asia/Manila', 
                hour: '2-digit', 
                minute: '2-digit', 
                second: '2-digit', 
                hour12: true 
            });
            
            // Display it in the injected container
            const timeContainer = document.getElementById('bwd-live-clock');
            if(timeContainer) {
                timeContainer.innerHTML = `<i class="fa fa-clock-o"></i> ${dateStr} - ${timeStr}`;
            }
        }
        
        // Run immediately, then tick every second
        updatePSTClock();
        setInterval(updatePSTClock, 1000); 
    });
    </script>
</head>