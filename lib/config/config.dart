///环境配置文件
bool debug = true; // 控制是否打印调试内容

class Config {

  static String getHost (env) {
    switch (env) {
      ///线上环境
      case "ON_LINE_DOWNLOAD_URL":
        return "http://downloads.hntxrj.com";
      case "ON_LINE_BASE_URL":
        return "https://api.hntxrj.com/v1";
      case "ON_LINE_ERP_URL":
        return "https://dev.erp.hntxrj.com";
      case "ON_LINE_DRIVER_URL":
        return "http://driver.erp.hntxrj.com";

      ///开发环境
      case "TEST_DOWNLOAD_URL":
        return "";
      case "TEST_BASE_URL":
        return "http://192.168.31.88:9501";
      case "TEST_ERP_URL":
        return "http://192.168.31.88:8088";
      case "TEST_DRIVER_URL":
        return "http://192.168.31.88:9222";
      default:
        return null;
    }
  }
}