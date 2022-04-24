front_matter_str = """---
layout: default
title: ProtonDB Analysis
parent: Data Analysis
grand_parent: Projects
nav_order: 1
---"""

import subprocess
import shutil
import os

# function that will prepend given string to given filename
def prepend_string(filename, string):
    with open(filename, "r+") as f:
        content = f.read()
        f.seek(0, 0)
        f.write(string.rstrip("\r\n") + "\n" + content)


def move_files(filename):
    """
    this function will move all files in source directory to correct path for jekyll

    Args:
        filename: source ipynb file
    """
    if not os.path.exists("iframe_figures"):
        return
    filename = os.path.splitext(filename)[0]
    os.makedirs(filename + "/" + "iframe_figures", exist_ok=True)
    shutil.copytree(
        "iframe_figures", filename + "/" + "iframe_figures", dirs_exist_ok=True
    )
    shutil.rmtree("iframe_figures")


def conv_nb_jekyll(filename, front_matter):

    """
    this function will convert your jupyter notebook to md and
    prepend the front matter string you provide to the top of the resulting md file

    Args:
        filename: filename of input jupyter notebook (.ipynb file)
        front_matter: python formatted string resembling YAML jekyll front matter
    """

    # convert jupyter notebook to md
    subprocess.call(
        [
            "jupyter",
            "nbconvert",
            "--to",
            "markdown",
            "--no-input",
            filename,
        ]
    )

    # call function to prepend front matter to the file
    md_file = filename.replace(".ipynb", ".md")
    prepend_string(md_file, front_matter)

    move_files(filename)

    return md_file


jekyll_html_post = conv_nb_jekyll(
    filename="analysis.ipynb", front_matter=front_matter_str
)
