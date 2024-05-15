#using Mousetrap

#main() do app::Application
#    window = Window(app)
#    set_child!(window, Label("Hello World!"))
#    present!(window)
#    column_view = ColumnView(SELECTION_MODE_NONE)
#    for column_i in 1:4
#        column = push_back_column!(column_view, "Column #$column_i")
#        for row_i in 1:3
#            set_widget_at!(column_view, column, row_i, Label("$row_i | $column_i"))
#        end
#    end
    #push_back_row!(column_view, Button(), CheckButton(), Entry(), Separator())        
#    set_child!(window, column_view)
    #button = Button()
    #set_child!(button, Label("Click Me"))
    #connect_signal_clicked!(button) do x::Button
    #    println("clicked!")
    #end
    #set_child!(window, button)
#end
