/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package yoreportero.database;

import java.sql.*;

/**
 *
 * @author alonso
 */
public class YoReporteroConnection {

    String driver = "org.postgresql.Driver";
    String constr = "jdbc:postgresql://localhost:5432/yoReportero/";
    String usernm = "postgres";
    String passwd = "12345";
    Connection db;

    public YoReporteroConnection() {
        try {
            Class.forName(driver);
            db = DriverManager.getConnection(constr, usernm, passwd);
        } catch (SQLException sqlEx) {
            System.out.println(sqlEx.getMessage());
            db = null;
        } catch (ClassNotFoundException cnfEx) {
            System.out.println(cnfEx.getMessage());
            db = null;
        }
    }

    public ResultSet ejecutarConsulta(String query) throws SQLException {
        Statement st = db.createStatement();
        ResultSet rs = st.executeQuery(query);
        return rs;
    }
}
