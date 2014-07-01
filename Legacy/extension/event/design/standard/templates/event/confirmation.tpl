<section class="lowerSection">
    <div id="utils">
        <div class="wrapper">
            {include uri="design:common/breadcrumb.tpl"}
            {include uri="design:common/social_tools.tpl"}
        </div>
    </div>

    <div class="wrapper">
        <!-- colLarge -->
        <section class="colLarge">
            <article class="content">
                <header>
                    <h1>Merci !</h1>
                </header>

                {def $agenda = fetch('content', 'list', hash(
                    'parent_node_id', ezini('NodeSettings','RootNode','content.ini'),
                    'class_filter_type', 'include',
                    'class_filter_array', array('n_2_calendar_page' ),
                    'depth', 2 ))
                }

                <p class="heading">
                    Votre événement a bien été crée, il devra d'abord être validé par le Conseil Général avant d'être publié.
                    <br/><br/>
                  <a href ={$agenda.0.url_alias|ezurl}>
                      Retour au portail Sortir en Seine-et-Marne
                  </a>
                </p>
            </article>
        </section>
        <!-- /colLarge -->
    </div>
</section>