SELECT 
    pens.pen_id, 
    pens.user_id,
    pens.name,
    pens.description,
    users.name as username,
    users.img_url,
    stats.views,
    stats.comments,
    stats.loves,
    pens.forked,
    pens.html,
    pens.css,
    pens.js,
    html_scripts.html_tag_class,
    html_scripts.head_tag,
    ARRAY_AGG(css_stylesheets.stylesheet) as css_stylesheet,
    ARRAY_AGG(js_scripts.js_script) as js_script
    FROM pens
RIGHT OUTER JOIN html_scripts
    ON pens.pen_id = html_scripts.pen_id
RIGHT OUTER JOIN css_stylesheets
    ON pens.pen_id = css_stylesheets.pen_id
RIGHT OUTER JOIN js_scripts
    ON pens.pen_id = js_scripts.pen_id
RIGHT OUTER JOIN stats
    ON pens.pen_id = stats.pen_id
JOIN users
    ON pens.user_id = users.id
FULL JOIN likes
    ON pens.pen_id = likes.pen_id
FULL JOIN pen_comments
    ON pens.pen_id = pen_comments.pen_id
FULL JOIN views
    ON pens.pen_id = views.pen_id
WHERE pens.description LIKE $2 OR pens.name LIKE $2
GROUP BY
    users.name,
    users.img_url,
    pens.pen_id,
    stats.views,
    stats.comments,
    stats.loves,
    html_scripts.html_tag_class,
    html_scripts.head_tag
ORDER BY
    views
    DESC
    OFFSET $1
    LIMIT 6;