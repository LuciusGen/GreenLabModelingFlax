#!/usr/bin/env python
# coding: utf-8

# In[1]:


import tkinter as tk
import tkinter.ttk as ttk
import codecs


# In[2]:


rownames = ["%T__Tm__N____W__kW__b___bf___rnd__msk_param_dev.", 
           "%na__np__ni_nc__nf__nm__nt_xx_xx_xx_nb_0rg/Phyt",
           "%tfa__tfp__tfi__tfc_tff__tfm_tft_tw__xx_org_funct.duration",
            "%txa__txp__txi__txc_txf__txm_txt_xx_xx_org_expan.duration",
            "%txo_n_ctl_step1_step2_step3_step4_control_expantion_steps",
            "%step1(a___p___i___f___m)_xx_xx_xx_xx_%of_expansion_time",
            "%step2(a___p___i___f___m)_xx_xx_xx_xx_of_expansion_time",
            "%step3(a___p___i___f___m)_xx_xx_xx_xx_)_%of_expansion_time",
            "%step4(a___p___i___f___m)_xx_xx_xx_xx__%of_expansion_time",
            "%pa__pp____pi___pc__pf_pm__pt__pq_xx_sink_orgam_strenght",
            "%kpc_kpa_kpi_mna_ca_mnp_cp_mni_ci%special_sink_param",
            "%_void_",
            "%Ba(_a____p___i__c__f___m__t)_xx_xx_param1_sink_variation_betalaw",
            "%Bb(_a___p___i___c___f___m__t)_xx_xx_param2_Beta",
            "%DL(_a___p___i___c__f___m__t)_xx_xx_expansion_delay",
            "%e____b1____a1__f1_sQo__sSp___allometry_leaf_internode_fruit",
            "%E__Qo__aQo__aQr__r___Sp__kc_xx_xx_%functioning_prameters",
            "%comp__phyt__settings_Glsqr",
            "%xQo_xaQo_xr_xSp_xpp_xpi_xpc_xpf_xpm_chosing_params",
            "%xpt_kpc_kpa_kpi_x_14_x_15_x_16x_17_x_18sinks",
            "%sQo_sSp_x_21_x_22_x_23_x_24_xBa1_xBp1_xBi1_expanlaw_chosing_params",
            "%xBf1_xBm1_xBt1_xBa2_xBp2_xBi2_xBf2_xBm2_xBt2___expansionlaw",
            "%modE__Eo___cor_wE__bE__Lmax_Lmin_Lightparam",
            "%modH_c1___c2___Hmx_Hmn_H1_psi__pH20_dH20_Hydroparam"
           ]
# изменить цвет бэка для полей, которые необходимо изменить
null_data = [
    ['1', '1', '1', '1', '1', '1', '7.31867', '1'],
    ['1', '1', '1', '1', '1', '1', '1', '1'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['3', '1', '6', '12', '0', '0', '0', '0'],
    ['0.33', '0.33', '0.08', '1', '1', '1', '1', '0', '0'],
    ['0.66', '0.66', '0.25', '1', '1', '1', '1', '0', '0'],
    ['1', '1', '1', '1', '1', '1', '1', '0', '0'],
    ['1', '1', '1', '1', '1', '1', '1', '0', '0'],
    ['1', '1', '1', '1', '1', '1', '1', '1'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['1', '1', '1', '1', '1', '1', '1', '1'],
    ['1', '1', '1', '1', '1', '1', '1', '1'],
    ['1', '1', '1', '1', '1', '1', '1', '1'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['1', '0.982601', '1', '0', '18.2036', '1200.53', '1', '0', '0'],
    ['1', '1', '0', '0', '0', '0', '0', '0'],
    ['1', '0', '1', '1', '1', '0', '1', '1'],
    ['0', '0', '0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '1', '1', '1'],
    ['1', '0', '0', '0', '0', '0', '0', '0'],
    ['1', '0', '0', '0', '0', '0', '0', '0'],
    ['0', '0', '0', '0', '0', '0', '0', '0']
            ]


# In[3]:


class SimpleTableInput(tk.Frame):
    def __init__(self, parent, rows, columns):
        tk.Frame.__init__(self, parent)

        self._entry = {}
        self.rows = rows
        self.columns = columns

        # register a command to use for validation
        vcmd = (self.register(self._validate), "%P")
        
        for column in range(self.columns):
            l = tk.Label(self, text = str(column + 1))
            l.grid(row = 0, column = column)
        
        for row in range(1, self.rows + 1):
            for column in range(self.columns):
                index = (row - 1, column)
                e = tk.Entry(self, validate="key", validatecommand=vcmd)
                e.insert(0, null_data[row - 1][column])
                e.grid(row=row, column=column, stick="nsew")
                self._entry[index] = e
        
        for i in range(1, self.rows + 1):
            l = tk.Label(self, text = str(i))
            l.grid(row = i, column = self.columns)
        
        # adjust column weights so they all expand equally
        for column in range(self.columns):
            self.grid_columnconfigure(column, weight=1)
        # designate a final, empty row to fill up any extra space
        self.grid_rowconfigure(rows, weight=1)

    def get(self):
        '''Return a list of lists, containing the data in the table'''
        result = []
        for row in range(self.rows):
            current_row = []
            for column in range(self.columns):
                index = (row, column)
                current_row.append(self._entry[index].get())
            result.append(current_row)
        return result

    def _validate(self, P):
        '''Perform input validation. 

        Allow only an empty value, or a value that can be converted to a float
        '''
        if P.strip() == "":
            return True

        try:
            f = float(P)
        except ValueError:
            self.bell()
            return False
        return True

class Example(tk.Frame):
    def __init__(self, parent):
        tk.Frame.__init__(self, parent)
        self.table = SimpleTableInput(self, 24, 8)
        self.submit = tk.Button(self, text="Submit", command=self.on_submit)
        self.table.pack(side="top", fill="both", expand=True)
        self.submit.pack(side="bottom")

    def on_submit(self):
        f = open("res_par.txt", 'w')
        res = self.table.get()
        
        for i in range(len(res)):
            f.write(rownames[i] + '\n')
            for j in range(len(res[i])):
                f.write(res[i][j] + " ")
            f.write(str(i + 1) + "\n")
        
        f.close()
        
def help_click():
    showfile()
        
def showfile():
    top = tk.Toplevel()
    top.title("help.txt")
    textArea = tk.Text(top)

    scrollbar = ttk.Scrollbar(top, command=textArea.yview)
    scrollbar.grid(row=0, column=1, sticky='nsew')

    textArea['yscrollcommand'] = scrollbar.set

    with codecs.open('help.txt', encoding='utf-8') as infile:
        textArea.insert(tk.END, infile.read())

    textArea.grid(row=0, column=0)
    textArea.config(state=tk.DISABLED)
        
        
root = tk.Tk()
Example(root).pack(side="top", fill="both", expand=True)

main_menu = tk.Menu()
main_menu.add_cascade(label="Help", command=help_click)

root.config(menu=main_menu)

root.mainloop()


# In[ ]:




