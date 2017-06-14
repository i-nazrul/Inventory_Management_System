/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package inventory;

/**
 *
 * @author Nazrul_R_30
 */
import dao.DatabaseHelper;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JComboBox;

/**
 *
 * @author Nazrul_R_30
 */
public class ProductController {

    public static boolean savaPname(String pname) {
        Connection con = null;
        CallableStatement csmt = null;
        boolean t = true;
        try {
            con = DatabaseHelper.getConnection();
            csmt = con.prepareCall("{CALL saveProduct(?)}");
            csmt.setString(1, pname);
            t = csmt.execute();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                con.close();
                csmt.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return t;
    }

    public static void loadCombo(JComboBox combo) {
        Connection con = null;
        CallableStatement csmt = null;
        ResultSet rs = null;
        try {
            con = DatabaseHelper.getConnection();
            csmt = con.prepareCall("{CALL listProduct()}");
            csmt.execute();
            rs = csmt.getResultSet();
            List pList = new ArrayList();
            while (rs.next()) {
                pList.add(rs.getString(1));
            }
            combo.setModel(new DefaultComboBoxModel(pList.toArray()));
            combo.insertItemAt("Select One", 0);
            combo.setSelectedIndex(0);
        } catch (Exception e) {
            e.printStackTrace();
        }try {
            con.close();
            rs.close();
            csmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    public static boolean savaPurchase(String pname, String price, String date, String qty) {
        Connection con = null;
        CallableStatement csmt = null;
        boolean t = true;
        try {
            con = DatabaseHelper.getConnection();
            csmt = con.prepareCall("{CALL savePurchase(getProductId(?),?,?,?)}");
            csmt.setString(1, pname);
            csmt.setString(2, price);
            csmt.setString(3, date);
            csmt.setString(4, qty);
            t = csmt.execute();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                con.close();
                csmt.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return t;
    }
    public static boolean savaSale(String pname, String price, String date, String qty) {
        Connection con = null;
        CallableStatement csmt = null;
        boolean t = true;
        try {
            con = DatabaseHelper.getConnection();
            csmt = con.prepareCall("{CALL saveSale(getProductId(?),?,?,?)}");
            csmt.setString(1, pname);
            csmt.setString(2, price);
            csmt.setString(3, date);
            csmt.setString(4, qty);
            t = csmt.execute();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                con.close();
                csmt.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return t;
    }
}
