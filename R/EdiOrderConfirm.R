
#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#' @param erp_token
#'
#' @return 返回值
#' @export
#'
#' @examples
#' EdiOrderConfirmUpdateServer()
EdiOrderConfirmUpdateServer <- function(input,output,session,dms_token,erp_token) {
  #获取参数

  text_EdiOrderConfirm_FBillNO = tsui::var_text('text_EdiOrderConfirm_FBillNO')

  text_EdiOrderConfirm_FSeq = tsui::var_text('text_EdiOrderConfirm_FSeq')

  text_EdiOrderConfirm_FCommittedQuantity = tsui::var_text('text_EdiOrderConfirm_FCommittedQuantity')

  text_EdiOrderConfirm_FCommittedQuantityUOM = tsui::var_text('text_EdiOrderConfirm_FCommittedQuantityUOM')

  text_EdiOrderConfirm_FCommittedQuantityConfirmedDate = tsui::var_text('text_EdiOrderConfirm_FCommittedQuantityConfirmedDate')
  text_EdiOrderConfirm_FErpDeliveryDate = tsui::var_text('text_EdiOrderConfirm_FErpDeliveryDate')

  text_EdiOrderConfirm_FBillNO_view = tsui::var_text('text_EdiOrderConfirm_FBillNO_view')

  text_EdiOrderConfirm_FSeq_view = tsui::var_text('text_EdiOrderConfirm_FSeq_view')


  text_EdiOrderConfirm_FBillNO_sync = tsui::var_text('text_EdiOrderConfirm_FBillNO_sync')

  shiny::observeEvent(input$btn_EdiOrderConfirm_update, {

    FBillNO <- text_EdiOrderConfirm_FBillNO()
    FSeq <- text_EdiOrderConfirm_FSeq()
    FCommittedQuantity <- text_EdiOrderConfirm_FCommittedQuantity()
    FCommittedQuantityUOM <- text_EdiOrderConfirm_FCommittedQuantityUOM()
    FCommittedQuantityConfirmedDate <- text_EdiOrderConfirm_FCommittedQuantityConfirmedDate()
    FErpDeliveryDate   <- text_EdiOrderConfirm_FErpDeliveryDate()

    # 判断销售订单号或行号是否为空
    if (is.null(FBillNO) || FBillNO == "" || is.null(FSeq) || FSeq == "") {
      tsui::pop_notice("销售订单号和行号不能为空")

    }
    else{
      mdlEdiOrderConfirmPkg::EdiOrderConfirm_update(erp_token = erp_token,
        FMessageNumber = FBillNO,
        FLineItemNumber = FSeq,
        FCommittedQuantity = FCommittedQuantity,
        FCommittedQuantityUOM = FCommittedQuantityUOM,
        FCommittedQuantityConfirmedDate = FCommittedQuantityConfirmedDate,FErpDeliveryDate = FErpDeliveryDate
      )

      tsui::pop_notice('更新成功')



    }




  })



  shiny::observeEvent(input$btn_EdiOrderConfirm_view, {


    FBillNO <- text_EdiOrderConfirm_FBillNO_view()
    FSeq <- text_EdiOrderConfirm_FSeq_view()
    data = mdlEdiOrderConfirmPkg::EdiOrderConfirm_view(erp_token = erp_token,FMessageNumber = FBillNO,FLineItemNumber = FSeq)


    tsui::run_dataTable2(id ='EdiOrderConfirm_resultView' ,data = data)


    tsui::run_download_xlsx(id ='dl_EdiOrderConfirm' ,data = data,filename = '销售订单.xlsx')

  })



  shiny::observeEvent(input$btn_EdiOrderConfirm_sync, {

    FBillNO = text_EdiOrderConfirm_FBillNO_sync()


    mdlEdiOrderConfirmPkg::EdiOrderConfirm_sync(erp_token =erp_token ,FMessageNumber = FBillNO)


    data_header = mdlEdiOrderConfirmPkg::EdiOrderHeader_view(erp_token = erp_token,FMessageNumber = FBillNO)


    tsda::db_writeTable2(token = dms_token,table_name = 'rds_dms_ods_t_edi_salesOrder',r_object = data_header,append = TRUE)


    data_item = mdlEdiOrderConfirmPkg::EdiOrderItem_view(erp_token = erp_token,FMessageNumber = FBillNO)


    tsda::db_writeTable2(token = dms_token,table_name = 'rds_dms_ods_t_edi_salesOrderEntry',r_object = data_item,append = TRUE)


    mdlEdiOrderConfirmPkg::EdiOrderFIsDo_update(erp_token = erp_token,FMessageNumber = FBillNO)
    tsui::pop_notice('同步成功')

  })



}


#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#' @param erp_token
#'
#' @return 返回值
#' @export
#'
#' @examples
#' EdiOrderConfirmServer()
EdiOrderConfirmServer <- function(input,output,session,dms_token,erp_token) {
  EdiOrderConfirmUpdateServer(input = input,output = output,session = session,dms_token = dms_token,erp_token = erp_token)

}
