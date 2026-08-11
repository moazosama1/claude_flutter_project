abstract class EndPoints {
  // TODO: Supabase excluded from this project. Replace baseUrl and endpoints
  // below with the target backend once the API layer is finalised.
  static const String baseUrl = "https://lurtqaiiuwftymtuzvci.supabase.co";

  // Edge Functions
  static const String authLogin = "/functions/v1/auth-login";
  static const String authRegister = "/functions/v1/auth-register";
  static const String authLogout = "/functions/v1/auth-logout";
  static const String authRefresh = "/auth/v1/token?grant_type=refresh_token";

  // Rest endpoints
  static const String users = "/rest/v1/users";
  static const String sales = "/rest/v1/sales";
  static const String employees = "/rest/v1/employees";
  static const String salesConfig = "/rest/v1/rpc/get_sales_config";
  static const String currency = "/rest/v1/currencies";
  static const String dailyMetrics = "/rest/v1/daily_metrics";
  static const String productType = "/rest/v1/product_types";
  static const String visaDiscount = "/rest/v1/visa_discount";
  static const String suppliers = "/rest/v1/suppliers";
  static const String supplierTransactions = "/rest/v1/supplier_transactions";
  static const String expenses = "/rest/v1/expenses";
  static const String vaultTransfers = "/rest/v1/vault_transfers";
  static const String executeCurrencyExchange =
      "/rest/v1/rpc/execute_currency_exchange";
  static const String walletDashboardSummary =
      "/rest/v1/wallet_dashboard_summary";
  static const String treasury = "/rest/v1/treasury";
  static const String employeeDailyPayroll =
      "/rest/v1/employee_daily_payroll_view";
  static const String employeeLedger = "/rest/v1/employee_ledger_view";
  static const String dashboardExpensesSummary =
      "/rest/v1/dashboard_expenses_summary_view";
  static const String loanAccounts = "/rest/v1/loan_accounts";
  static const String loanTransactions = "/rest/v1/loan_transactions";
  static const String loanAccountsSummary = "/rest/v1/loan_accounts_summary";
  static const String dayClosingSummary = "/rest/v1/day_closing_summary_view";
  static const String payAllPendingSalaries =
      "/rest/v1/rpc/pay_all_pending_salaries";
  static const String payEmployeePendingSalary =
      "/rest/v1/rpc/pay_employee_pending_salary";
  static const String dayClosings = "/rest/v1/day_closings";
  static const String visaExpensesView = "/rest/v1/visa_expenses_unified_view";

  static const String profitReport = "/rest/v1/rpc/fn_get_profit_report";
  static const String expensesReport = "/rest/v1/rpc/fn_get_expenses_report";
  static const String partnersProfits = "/rest/v1/rpc/fn_get_partners_profits";
  static const String yearlyDailyProfits =
      "/rest/v1/rpc/fn_get_yearly_daily_profits";

  static const String partnerNetPosition = "/rest/v1/partner_net_position";
  static const String partnerProfitsBetweenDates =
      "/rest/v1/rpc/get_partner_profits_between_dates";
  static const String partnerLedger = "/rest/v1/partner_ledger_view";
  static const String capitalTracking = "/rest/v1/capital_tracking";

  static const String moneyPools = "/rest/v1/money_pools_summary";
  static const String moneyPoolsCreate = "/rest/v1/money_pools";
  static const String moneyPoolTransactions =
      "/rest/v1/money_pool_transactions";
  static const String addMoneyPoolTransaction =
      "/rest/v1/rpc/fn_add_money_pool_transaction";
  static const String registerLitigationTransaction =
      "/rest/v1/rpc/fn_register_litigation_transaction";

  static const String idQuery = "id";

  // Queries Values
  static String userIdQuery(String id) => "eq.$id";
}
