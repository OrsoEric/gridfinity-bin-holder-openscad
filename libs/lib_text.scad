//	lib_text.scad
//	Author: Orso Eric
//	Date: 2025-09-10

/**
 * Generates a single line of 3D text.
 *
 * Parameters:
 *   i_s_text: The text string to render. Default: "TesT".
 *   i_l_text: The size (length) of the text. Default: 6.
 *   i_h_text: The height of the extruded text. Default: 1.
 * 	 i_x_mirror: text extruded from bottom surfaces needs to be mirrored
 */

module text_line
(
    i_s_text = "TesT",
    i_l_text = 6,
    i_h_text = 1,
	//text extruded from bottom surfaces needs to be mirrored
	i_x_mirror = false
)
{
	//Optionally mirror horizontally to extrude from bottom surfaces
	mirror([i_x_mirror?1:0,0,0])
	// Extrude the text along the z-axis to give it height
    linear_extrude(i_h_text)
    text(
        text = i_s_text,
        size = i_l_text,
        font = "DejaVu Sans:style=Bold",  // Use bold DejaVu Sans font
        halign = "center",                // Horizontally center the text
        valign = "center"                 // Vertically center the text
    );
}

if (false)
text_line
(
    i_s_text = "TesT",
    i_l_text = 6,
    i_h_text = 1,
	i_x_mirror = false
);

/**
 * Generates multiple lines of 3D text, arranged vertically with a specified margin.
 *
 * Parameters:
 *   i_as_text: An array of text strings to render. Default: ["LOOOOOONG", "SHRT"].
 *   i_l_text: The size (length) of each text line. Default: 6.
 *   i_h_text: The height of the extruded text. Default: 1.
 *   i_m_line: The margin between lines. Default: 1.
 * 	 i_x_mirror: text extruded from bottom surfaces needs to be mirrored
 */

module text_lines
(
    i_as_text = ["LOOOOOONG", "SHRT"],
    i_l_text = 6,
    i_h_text = 1,
    // Margin between lines
    i_m_line = 1,
	//text extruded from bottom surfaces needs to be mirrored
	i_x_mirror = false
)
{
    // Calculate the number of lines
    n_lines = len(i_as_text);
    // Calculate the total width occupied by all lines, including margins
    w_text = (n_lines - 1) * (i_l_text + i_m_line);

    // Only proceed if there are lines to render
    if (n_lines > 0)
        for (n_index = [0:n_lines-1])
            let(
                // Calculate the minimum and maximum width for centering
                w_min = w_text / 2,
                w_max = -w_text / 2,
                w_delta = w_max - w_min,
                // Calculate the offset for the current line to center it
                w_offset = w_min + w_delta * n_index / (n_lines - 1)
            )
            // Move the text to its calculated position and extrude it
            translate([0, w_offset, 0])
			text_line
			(
				i_s_text = i_as_text[n_index],
				i_l_text = i_l_text,
				i_h_text = i_h_text,
				i_x_mirror = i_x_mirror
			);
}

// Reder the text_lines module
if (false)
text_lines
(
    i_as_text = ["LOOOOOONG", "SHRT"],
    i_l_text = 6,
    i_h_text = 1,
    // Margin between lines
    i_m_line = 1,
	//Mirror horizontally for bottom extrusion
	i_x_mirror = true
);
