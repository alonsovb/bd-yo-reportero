/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package yoreportero.desktop;

import javax.swing.UIManager;
import yoreportero.database.YoReporteroConnection;
import yoreportero.frameset.dialogLogin;
import yoreportero.frameset.frameMain;

/**
 *
 * @author alonso
 */
public class YoReporteroDesktop {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        YoReporteroConnection rc;
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            System.out.println("Error en el L&F");
            return;
        }
        rc = new YoReporteroConnection();
        dialogLogin dl = new dialogLogin(null, true, rc);
        dl.setVisible(true);
        if (dl.isCorrect()) {
            frameMain mf = new frameMain(rc, dl.getUsuario());
            mf.setVisible(true);
        }
    }
}
