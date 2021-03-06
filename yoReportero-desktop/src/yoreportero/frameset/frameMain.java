/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * MainFrame.java
 *
 * Created on Nov 15, 2011, 4:23:34 PM
 */
package yoreportero.frameset;

import yoreportero.database.YoReporteroConnection;

/**
 *
 * @author alonso
 */
public final class frameMain extends javax.swing.JFrame {

    protected String username;
    protected String password;
    YoReporteroConnection connection;

    /** Creates new form MainFrame */
    public frameMain(YoReporteroConnection connection, String username) {
        initComponents();
        setExtendedState(MAXIMIZED_BOTH);
        this.connection = connection;
        tabMain.addTab("Stream", new panelStream(connection, username));
        tabMain.addTab("Profile", new panelProfile(connection, username));
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        panelNavigation = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        tabMain = new javax.swing.JTabbedPane();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("yoReportero");
        setBackground(java.awt.Color.white);

        panelNavigation.setBackground(new java.awt.Color(107, 107, 107));

        jLabel1.setFont(new java.awt.Font("Ubuntu", 1, 18));
        jLabel1.setForeground(java.awt.Color.white);
        jLabel1.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        jLabel1.setText("yoReportero");
        jLabel1.setToolTipText("");

        javax.swing.GroupLayout panelNavigationLayout = new javax.swing.GroupLayout(panelNavigation);
        panelNavigation.setLayout(panelNavigationLayout);
        panelNavigationLayout.setHorizontalGroup(
            panelNavigationLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panelNavigationLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, 633, Short.MAX_VALUE)
                .addContainerGap())
        );
        panelNavigationLayout.setVerticalGroup(
            panelNavigationLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panelNavigationLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, 26, Short.MAX_VALUE)
                .addContainerGap())
        );

        tabMain.setBackground(java.awt.Color.white);
        tabMain.setTabPlacement(javax.swing.JTabbedPane.LEFT);
        tabMain.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                tabMainStateChanged(evt);
            }
        });
        tabMain.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentShown(java.awt.event.ComponentEvent evt) {
                tabMainComponentShown(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(panelNavigation, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(tabMain, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 657, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(panelNavigation, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(tabMain, javax.swing.GroupLayout.DEFAULT_SIZE, 334, Short.MAX_VALUE))
        );

        tabMain.getAccessibleContext().setAccessibleName("Login");

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void tabMainComponentShown(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_tabMainComponentShown
    }//GEN-LAST:event_tabMainComponentShown

    private void tabMainStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_tabMainStateChanged
        if (tabMain.getTabCount() > 1) {
            panelProfile pp = (panelProfile) tabMain.getComponentAt(1);
            pp.showFollowing();
            pp.showPosts();
            panelStream ps = (panelStream) tabMain.getComponentAt(0);
            ps.ActualizarPosts();
            ps.ActualizarUsuarios();
        }
    }//GEN-LAST:event_tabMainStateChanged
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JPanel panelNavigation;
    private javax.swing.JTabbedPane tabMain;
    // End of variables declaration//GEN-END:variables
}
