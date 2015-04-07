This is an ABOUT page
<br />
<%=Html.ActionLink("Index", "Home", "Index" ) %>
<br />
<%=Html.ActionLink("About", "Home", "About" ) %>
<br />
<%=Html.ActionLink("Abandon session", "Home", "AbandonSession" ) %>
<br />
<br />

The <strong>About</strong> Page was visited <%=Html.Encode(Model) %> times </br>

Here is the link to one of the "standard" UserConteroller, which works with the database.
<%=Html.ActionLink("List Users", "User", "List" ) %> (
<a href="#" onclick="toggleVisibility('instructions')"> Instructions</a> )
</br>
<div id='instructions' style='visibility:hidden'>
In order to use the UserController you need to set up the MS SQL database;</br>
 Create table <strong>User</strong> in the database.</br>
 Create fields (refer the <strong>User</strong> model in this solution</br>
 Create connection string and save it in the /utils/connectionString.asp </br>
</div>

<script language="javascript">
    function toggleVisibility(controlId) {
        var control = document.getElementById(controlId);
        if (control.style.visibility == "visible" || control.style.visibility == "")
            control.style.visibility = "hidden";
        else
            control.style.visibility = "visible";

    }
</script>
